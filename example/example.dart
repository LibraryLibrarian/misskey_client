// ignore_for_file: avoid_print
import 'package:misskey_client/misskey_client.dart';

void main() async {
  // -------------------------------------------------------
  // 1. Initialize the client
  // -------------------------------------------------------
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      enableLog: true,
    ),
    // Supports both sync and async token retrieval
    tokenProvider: () => 'your_access_token',
  );

  // -------------------------------------------------------
  // 2. Fetch server info (no authentication required)
  // -------------------------------------------------------
  final meta = await client.meta.getMeta();
  print('Server: ${meta.name}');
  print('Version: ${meta.version}');

  // Feature detection via dot-notation key path
  if (client.meta.supports('policies.canInvite')) {
    print('This server allows invitations.');
  }

  // -------------------------------------------------------
  // 3. Verify the authenticated user
  // -------------------------------------------------------
  final me = await client.account.i();
  print('Logged in as: ${me.username}');

  // -------------------------------------------------------
  // 4. Post a note
  // -------------------------------------------------------
  final note = await client.notes.create(
    text: 'Hello from misskey_client!',
    visibility: 'public',
  );
  print('Posted: ${note.id}');

  // With content warning
  await client.notes.create(
    text: 'Spoiler content here',
    cw: 'Spoiler warning',
  );

  // With files and a poll
  await client.notes.create(
    text: 'Check this out!',
    fileIds: ['drive_file_id_1'],
    pollChoices: ['Option A', 'Option B'],
    pollExpiresAt: DateTime.now()
        .add(const Duration(hours: 24))
        .millisecondsSinceEpoch,
  );

  // -------------------------------------------------------
  // 5. Pagination
  // -------------------------------------------------------
  final firstPage = await client.notifications.list(limit: 20);
  for (final n in firstPage) {
    print('${n.type}: ${n.id}');
  }

  // Fetch the next (older) page
  if (firstPage.length == 20) {
    final nextPage = await client.notifications.list(
      limit: 20,
      untilId: firstPage.last.id,
    );
    print('Next page: ${nextPage.length} items');
  }

  // Iterate through all pages
  final all = <MisskeyNotification>[];
  String? cursor;

  while (true) {
    final page = await client.notifications.list(
      limit: 100,
      untilId: cursor,
      markAsRead: false,
    );
    all.addAll(page);

    if (page.length < 100) break;
    cursor = page.last.id;
  }
  print('Total notifications: ${all.length}');

  // -------------------------------------------------------
  // 6. Error handling
  // -------------------------------------------------------
  try {
    await client.notes.show(noteId: 'invalid_id');
  } on MisskeyNotFoundException {
    print('Note not found');
  } on MisskeyUnauthorizedException {
    print('Invalid token');
  } on MisskeyRateLimitException catch (e) {
    print('Rate limited — retry after ${e.retryAfter}');
  } on MisskeyClientException catch (e) {
    print('Error: $e');
  }
}
