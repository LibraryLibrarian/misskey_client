import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';

/// Returns an ID whose lexical ordering matches its numeric ordering.
String idAt(int n) => 'id${n.toString().padLeft(10, '0')}';

/// Creates JSON accepted by [MisskeyDriveFile.fromJson].
Map<String, dynamic> driveFileJson({
  required String id,
  String? folderId,
  String name = 'file.png',
  int size = 100,
  String type = 'image/png',
  String md5 = 'd41d8cd98f00b204e9800998ecf8427e',
  DateTime? createdAt,
  bool isSensitive = false,
}) => {
  'id': id,
  'createdAt': (createdAt ?? DateTime.utc(2026)).toIso8601String(),
  'name': name,
  'type': type,
  'size': size,
  'md5': md5,
  'url': 'https://misskey.example.com/files/$id',
  'folderId': folderId,
  'isSensitive': isSensitive,
};

/// Creates JSON accepted by [MisskeyDriveFolder.fromJson].
Map<String, dynamic> driveFolderJson({
  required String id,
  String? parentId,
  String name = 'folder',
  DateTime? createdAt,
  int? foldersCount,
  int? filesCount,
  Map<String, dynamic>? parent,
}) => {
  'id': id,
  'createdAt': (createdAt ?? DateTime.utc(2026)).toIso8601String(),
  'name': name,
  'parentId': parentId,
  'foldersCount': ?foldersCount,
  'filesCount': ?filesCount,
  'parent': ?parent,
};

/// Creates JSON accepted by [MisskeyUser.fromJson].
Map<String, dynamic> userJson({
  String id = 'user1',
  Map<String, dynamic>? policies,
  bool isModerator = false,
  bool isAdmin = false,
}) => {
  'id': id,
  'username': 'test-user',
  'name': 'Test user',
  'isModerator': isModerator,
  'isAdmin': isAdmin,
  'policies': ?policies,
};

/// Creates an authenticated client connected to a test adapter.
MisskeyClient testClient(HttpClientAdapter adapter) => MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'test-token',
  httpClientAdapter: adapter,
);
