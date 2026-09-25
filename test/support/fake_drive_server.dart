import 'dart:collection';

import 'package:crypto/crypto.dart' show md5;
import 'package:misskey_client/misskey_client.dart';

import 'drive_fixtures.dart';
import 'scripted_http_adapter.dart';

/// An in-memory Drive API server for helper tests.
class FakeDriveServer {
  FakeDriveServer({
    String Function(List<int> bytes)? md5Of,
    Map<String, dynamic>? policies,
    bool isModerator = false,
    bool isAdmin = false,
    this.capacity = 1024 * 1024 * 1024,
  }) : _md5Of = md5Of ?? _stableHash,
       _policies = policies,
       _isModerator = isModerator,
       _isAdmin = isAdmin,
       adapter = ScriptedHttpClientAdapter() {
    client = testClient(adapter);
    _installHandlers();
  }

  /// The transport backing [client].
  final ScriptedHttpClientAdapter adapter;

  /// An authenticated client connected to this server.
  late final MisskeyClient client;

  /// The total reported Drive capacity in bytes.
  final int capacity;

  /// Keeps deleted rows visible for this many subsequent folder-delete requests.
  ///
  /// Every normally handled `/drive/folders/delete` request advances this
  /// deterministic lag after its child check has run.
  int fileDeletionLagRequests = 0;

  final String Function(List<int> bytes) _md5Of;
  final Map<String, dynamic>? _policies;
  final bool _isModerator;
  final bool _isAdmin;
  final List<FakeFile> _files = [];
  final List<FakeFolder> _folders = [];
  final List<_PendingFile> _pendingDeletion = [];
  final List<_Fault> _faults = [];
  int _counter = 0;

  /// Active files in insertion order.
  UnmodifiableListView<FakeFile> get files => UnmodifiableListView(_files);

  /// Active folders in insertion order.
  UnmodifiableListView<FakeFolder> get folders =>
      UnmodifiableListView(_folders);

  /// Adds a folder and returns its mutable server-side record.
  FakeFolder addFolder({String? parentId, String name = 'folder'}) {
    if (parentId != null && _folder(parentId) == null) {
      throw ArgumentError.value(
        parentId,
        'parentId',
        'must name an existing folder',
      );
    }
    final folder = FakeFolder(
      id: _newId(),
      parentId: parentId,
      name: name,
      createdAt: DateTime.utc(2026).add(Duration(seconds: _counter)),
    );
    _folders.add(folder);
    return folder;
  }

  /// Adds a file and returns its mutable server-side record.
  FakeFile addFile({
    String? folderId,
    String name = 'file.png',
    int size = 100,
    String type = 'image/png',
    String md5 = 'd41d8cd98f00b204e9800998ecf8427e',
  }) {
    if (folderId != null && _folder(folderId) == null) {
      throw ArgumentError.value(
        folderId,
        'folderId',
        'must name an existing folder',
      );
    }
    final file = FakeFile(
      id: _newId(),
      folderId: folderId,
      name: name,
      size: size,
      type: type,
      md5: md5,
      createdAt: DateTime.utc(2026).add(Duration(seconds: _counter)),
    );
    _files.add(file);
    return file;
  }

  /// Makes matching requests return [response] before normal handling.
  void failWhen(
    String path,
    bool Function(RecordedRequest request) predicate,
    ScriptedResponse response, {
    int times = 1,
  }) {
    if (times == 0 || times < -1) throw ArgumentError.value(times, 'times');
    _faults.add(_Fault(path, predicate, response, times));
  }

  String _newId() => idAt(++_counter);

  void _installHandlers() {
    for (final path in [
      '/drive/files',
      '/drive/folders',
      '/drive/stream',
      '/drive/folders/show',
      '/drive/folders/find',
      '/drive/folders/create',
      '/drive/folders/update',
      '/drive/folders/delete',
      '/drive/files/show',
      '/drive/files/update',
      '/drive/files/delete',
      '/drive/files/move-bulk',
      '/drive/files/find',
      '/drive/files/find-by-hash',
      '/drive/files/check-existence',
      '/drive/files/create',
      '/drive',
      '/i',
    ]) {
      adapter.on(path, _handle);
    }
  }

  ScriptedResponse _handle(RecordedRequest request) {
    for (final fault in _faults.toList()) {
      if (fault.path == request.path && fault.predicate(request)) {
        if (fault.remaining > 0 && --fault.remaining == 0) {
          _faults.remove(fault);
        }
        return fault.response;
      }
    }
    final body = request.jsonBody ?? const <String, dynamic>{};
    final response = switch (request.path) {
      '/drive/files' => _listFiles(body),
      '/drive/folders' => _listFolders(body),
      '/drive/stream' => _streamFiles(body),
      '/drive/folders/show' => _showFolder(body),
      '/drive/folders/find' => _findFolders(body),
      '/drive/folders/create' => _createFolder(body),
      '/drive/folders/update' => _updateFolder(body),
      '/drive/folders/delete' => _deleteFolder(body),
      '/drive/files/show' => _showFile(body),
      '/drive/files/update' => _updateFile(body),
      '/drive/files/delete' => _deleteFile(body),
      '/drive/files/move-bulk' => _moveBulk(body),
      '/drive/files/find' => _findFiles(body),
      '/drive/files/find-by-hash' => _findByHash(body),
      '/drive/files/check-existence' => _checkExistence(body),
      '/drive/files/create' => _createFile(request),
      '/drive' => ScriptedResponse.json({
        'capacity': capacity,
        'usage': _files.fold<int>(0, (sum, file) => sum + file.size),
      }),
      '/i' => ScriptedResponse.json(
        userJson(
          policies: _policies,
          isModerator: _isModerator,
          isAdmin: _isAdmin,
        ),
      ),
      _ => throw StateError('Unexpected fake Drive path: ${request.path}'),
    };
    if (request.path == '/drive/folders/delete') {
      _advanceDeletionLag();
    }
    return response;
  }

  ScriptedResponse _listFiles(Map<String, dynamic> body) {
    final limit = _limit(body);
    if (limit == null || !_validOptionalType(body['type'])) {
      return _validationError();
    }
    final folderId = body['folderId'] as String?;
    var values = _files.where((file) => file.folderId == folderId);
    values = _filterFiles(values, body);
    return ScriptedResponse.json(
      _page(values, body, limit).map(_fileJson).toList(),
    );
  }

  ScriptedResponse _streamFiles(Map<String, dynamic> body) {
    final limit = _limit(body);
    // stream の type は nullable ではないため、省略は許可し明示的な null のみ拒否する
    final typeInvalid =
        body.containsKey('type') && !_validRequiredType(body['type']);
    if (limit == null || typeInvalid) {
      return _validationError();
    }
    return ScriptedResponse.json(
      _page(_filterFiles(_files, body), body, limit).map(_fileJson).toList(),
    );
  }

  Iterable<FakeFile> _filterFiles(
    Iterable<FakeFile> source,
    Map<String, dynamic> body,
  ) {
    final type = body['type'] as String?;
    if (type == null) return source;
    if (type.endsWith('/*')) {
      final prefix = type.substring(0, type.length - 1);
      return source.where((file) => file.type.startsWith(prefix));
    }
    return source.where((file) => file.type == type);
  }

  ScriptedResponse _listFolders(Map<String, dynamic> body) {
    final limit = _limit(body);
    if (limit == null) return _validationError();
    final parentId = body['folderId'] as String?;
    return ScriptedResponse.json(
      _page(
        _folders.where((folder) => folder.parentId == parentId),
        body,
        limit,
      ).map(_folderJson).toList(),
    );
  }

  ScriptedResponse _showFolder(Map<String, dynamic> body) {
    if (!_requiredString(body, 'folderId')) return _validationError();
    final folder = _folder(body['folderId'] as String?);
    return folder == null
        ? _error('NO_SUCH_FOLDER')
        : ScriptedResponse.json(
            _folderJson(folder, counts: true, parent: true),
          );
  }

  ScriptedResponse _findFolders(Map<String, dynamic> body) {
    if (!_requiredString(body, 'name')) return _validationError();
    final name = body['name'];
    final parentId = body['parentId'] as String?;
    return ScriptedResponse.json(
      _folders
          .where((folder) => folder.name == name && folder.parentId == parentId)
          .map(_folderJson)
          .toList(),
    );
  }

  ScriptedResponse _createFolder(Map<String, dynamic> body) {
    final parentId = body['parentId'] as String?;
    if (parentId != null && _folder(parentId) == null) {
      return _error('NO_SUCH_FOLDER');
    }
    final folder = addFolder(
      parentId: parentId,
      name: (body['name'] as String?) ?? 'Untitled',
    );
    return ScriptedResponse.json(_folderJson(folder));
  }

  ScriptedResponse _updateFolder(Map<String, dynamic> body) {
    if (!_requiredString(body, 'folderId')) return _validationError();
    final folder = _folder(body['folderId'] as String?);
    if (folder == null) return _error('NO_SUCH_FOLDER');
    final parentId = body['parentId'] as String?;
    if (body.containsKey('parentId')) {
      if (parentId == folder.id ||
          (parentId != null && _isDescendant(parentId, folder.id))) {
        return _error('RECURSIVE_NESTING');
      }
      if (parentId != null && _folder(parentId) == null) {
        return _error('NO_SUCH_PARENT_FOLDER');
      }
    }
    if (body['name'] case final String name when name.isNotEmpty) {
      folder.name = name;
    }
    if (body.containsKey('parentId')) folder.parentId = parentId;
    return ScriptedResponse.json(_folderJson(folder));
  }

  ScriptedResponse _deleteFolder(Map<String, dynamic> body) {
    if (!_requiredString(body, 'folderId')) return _validationError();
    final folder = _folder(body['folderId'] as String?);
    if (folder == null) return _error('NO_SUCH_FOLDER');
    final hasChildren =
        _folders.any((item) => item.parentId == folder.id) ||
        _files.any((item) => item.folderId == folder.id);
    if (hasChildren) return _error('HAS_CHILD_FILES_OR_FOLDERS');
    _folders.remove(folder);
    return ScriptedResponse.noContent();
  }

  ScriptedResponse _showFile(Map<String, dynamic> body) {
    if (!_requiredString(body, 'fileId')) return _validationError();
    final file = _file(body['fileId'] as String?);
    return file == null
        ? _error('NO_SUCH_FILE')
        : ScriptedResponse.json(_fileJson(file));
  }

  ScriptedResponse _updateFile(Map<String, dynamic> body) {
    if (!_requiredString(body, 'fileId')) return _validationError();
    final file = _file(body['fileId'] as String?);
    if (file == null) return _error('NO_SUCH_FILE');
    final folderId = body['folderId'] as String?;
    if (body.containsKey('folderId') &&
        folderId != null &&
        _folder(folderId) == null) {
      return _error('NO_SUCH_FOLDER');
    }
    if (body['name'] case final String name) file.name = name;
    if (body['isSensitive'] case final bool value) file.isSensitive = value;
    if (body.containsKey('comment')) file.comment = body['comment'] as String?;
    if (body.containsKey('folderId')) file.folderId = folderId;
    return ScriptedResponse.json(_fileJson(file));
  }

  ScriptedResponse _deleteFile(Map<String, dynamic> body) {
    if (!_requiredString(body, 'fileId')) return _validationError();
    final file = _file(body['fileId'] as String?);
    if (file == null) return _error('NO_SUCH_FILE');
    if (fileDeletionLagRequests > 0 &&
        !_pendingDeletion.any((pending) => pending.file == file)) {
      _pendingDeletion.add(_PendingFile(file, fileDeletionLagRequests));
    } else if (fileDeletionLagRequests == 0) {
      _files.remove(file);
    }
    return ScriptedResponse.noContent();
  }

  ScriptedResponse _moveBulk(Map<String, dynamic> body) {
    final ids = body['fileIds'];
    if (ids is! List ||
        ids.isEmpty ||
        ids.length > 100 ||
        ids.toSet().length != ids.length ||
        !ids.every(_isMisskeyId)) {
      return _validationError();
    }
    final folderIdValue = body['folderId'];
    if (folderIdValue != null && !_isMisskeyId(folderIdValue)) {
      return _validationError();
    }
    final folderId = folderIdValue as String?;
    if (folderId != null && _folder(folderId) == null) {
      return ScriptedResponse.error(500, code: 'INTERNAL_ERROR');
    }
    for (final id in ids.whereType<String>()) {
      final file = _file(id);
      if (file != null) file.folderId = folderId;
    }
    return ScriptedResponse.noContent();
  }

  ScriptedResponse _findFiles(Map<String, dynamic> body) {
    if (!_requiredString(body, 'name')) return _validationError();
    final name = body['name'];
    final folderId = body['folderId'] as String?;
    return ScriptedResponse.json(
      _files
          .where((file) => file.name == name && file.folderId == folderId)
          .map(_fileJson)
          .toList(),
    );
  }

  ScriptedResponse _findByHash(Map<String, dynamic> body) {
    if (!_requiredString(body, 'md5')) return _validationError();
    return ScriptedResponse.json(
      _files.where((file) => file.md5 == body['md5']).map(_fileJson).toList(),
    );
  }

  ScriptedResponse _checkExistence(Map<String, dynamic> body) {
    if (!_requiredString(body, 'md5')) return _validationError();
    return ScriptedResponse.json(_files.any((file) => file.md5 == body['md5']));
  }

  ScriptedResponse _createFile(RecordedRequest request) {
    final fields = request.formFields;
    final bytes = request.formFileBytes ?? const <int>[];
    final md5 = _md5Of(bytes);
    final existing = _files.where((file) => file.md5 == md5).firstOrNull;
    final isSensitive = fields['isSensitive'] == 'true';
    if (fields['force'] != 'true' && existing != null) {
      if (isSensitive) existing.isSensitive = true;
      return ScriptedResponse.json(_fileJson(existing));
    }
    final folderId = fields['folderId'];
    if (folderId != null && _folder(folderId) == null) {
      return ScriptedResponse.error(500, code: 'INTERNAL_ERROR');
    }
    final file =
        addFile(
            folderId: folderId,
            name: fields['name'] ?? request.formFileNames.firstOrNull ?? 'file',
            size: bytes.length,
            type: 'application/octet-stream',
            md5: md5,
          )
          ..comment = fields['comment']
          ..isSensitive = isSensitive;
    return ScriptedResponse.json(_fileJson(file));
  }

  int? _limit(Map<String, dynamic> body) {
    final value = body.containsKey('limit') ? body['limit'] : 10;
    if (value is! int || value < 1 || value > 100) return null;
    return value;
  }

  List<T> _page<T extends _HasId>(
    Iterable<T> source,
    Map<String, dynamic> body,
    int limit,
  ) {
    var values = source.toList();
    final untilId = body['untilId'] as String?;
    final sinceId = body['sinceId'] as String?;
    if (untilId != null) {
      values = values.where((item) => item.id.compareTo(untilId) < 0).toList();
    }
    if (sinceId != null) {
      values = values.where((item) => item.id.compareTo(sinceId) > 0).toList();
    }
    values.sort(
      (a, b) => sinceId != null && untilId == null
          ? a.id.compareTo(b.id)
          : b.id.compareTo(a.id),
    );
    return values.take(limit).toList();
  }

  bool _isDescendant(String candidateId, String ancestorId) {
    var current = _folder(candidateId);
    while (current?.parentId != null) {
      if (current!.parentId == ancestorId) return true;
      current = _folder(current.parentId);
    }
    return false;
  }

  void _advanceDeletionLag() {
    for (final pending in _pendingDeletion.toList()) {
      if (--pending.remaining <= 0) {
        _pendingDeletion.remove(pending);
        _files.remove(pending.file);
      }
    }
  }

  FakeFolder? _folder(String? id) => id == null
      ? null
      : _folders.where((folder) => folder.id == id).firstOrNull;
  FakeFile? _file(String? id) =>
      id == null ? null : _files.where((file) => file.id == id).firstOrNull;

  Map<String, dynamic> _fileJson(FakeFile file) => driveFileJson(
    id: file.id,
    folderId: file.folderId,
    name: file.name,
    size: file.size,
    type: file.type,
    md5: file.md5,
    createdAt: file.createdAt,
    isSensitive: file.isSensitive,
  )..['comment'] = file.comment;

  Map<String, dynamic> _folderJson(
    FakeFolder folder, {
    bool counts = false,
    bool parent = false,
  }) => driveFolderJson(
    id: folder.id,
    parentId: folder.parentId,
    name: folder.name,
    createdAt: folder.createdAt,
    foldersCount: counts
        ? _folders.where((item) => item.parentId == folder.id).length
        : null,
    filesCount: counts
        ? _files.where((item) => item.folderId == folder.id).length
        : null,
    parent: parent && folder.parentId != null
        ? _folderJson(_folder(folder.parentId)!, counts: true, parent: true)
        : null,
  );

  static bool _requiredString(Map<String, dynamic> body, String key) =>
      body[key] is String;

  static bool _validOptionalType(Object? value) =>
      value == null || _validRequiredType(value);

  static bool _validRequiredType(Object? value) =>
      value is String && RegExp(r'^[a-zA-Z/\-*]+$').hasMatch(value);

  static ScriptedResponse _error(String code) =>
      ScriptedResponse.error(400, code: code);
  static bool _isMisskeyId(Object? value) =>
      value is String && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);

  static ScriptedResponse _validationError() => ScriptedResponse.json({
    'error': {
      'message': 'Invalid param.',
      'code': 'INVALID_PARAM',
      'id': '3d81ceae-475f-4600-b2a8-2bc116157532',
      'kind': 'client',
      'info': {'param': '', 'reason': ''},
    },
  }, status: 400);

  static String _stableHash(List<int> bytes) => md5.convert(bytes).toString();
}

/// Mutable file record exposed by [FakeDriveServer.files].
class FakeFile implements _HasId {
  FakeFile({
    required this.id,
    required this.folderId,
    required this.name,
    required this.size,
    required this.type,
    required this.md5,
    required this.createdAt,
  });

  @override
  final String id;
  String? folderId;
  String name;
  final int size;
  final String type;
  final String md5;
  final DateTime createdAt;
  bool isSensitive = false;
  String? comment;
}

/// Mutable folder record exposed by [FakeDriveServer.folders].
class FakeFolder implements _HasId {
  FakeFolder({
    required this.id,
    required this.parentId,
    required this.name,
    required this.createdAt,
  });

  @override
  final String id;
  String? parentId;
  String name;
  final DateTime createdAt;
}

abstract interface class _HasId {
  String get id;
}

class _PendingFile {
  _PendingFile(this.file, this.remaining);

  final FakeFile file;
  int remaining;
}

class _Fault {
  _Fault(this.path, this.predicate, this.response, this.remaining);

  final String path;
  final bool Function(RecordedRequest) predicate;
  final ScriptedResponse response;
  int remaining;
}
