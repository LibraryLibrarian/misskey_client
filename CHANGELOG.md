# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Admin API: complete coverage of all 99 `/api/admin/*` endpoints
  - Core admin (`AdminApi`): meta, update-meta, server-info, show-user, show-users, suspend-user, unsuspend-user, reset-password, update-user-note, delete-account, delete-all-files-of-a-user, unset-user-avatar, unset-user-banner, get-user-ips, show-moderation-logs, send-email, update-proxy-account, promo/create, get-index-stats, get-table-stats
  - Account management (`AdminAccountsApi`): create, delete, find-by-email
  - Role management (`AdminRolesApi`): list, show, create, update, delete, assign, unassign, update-default-policies, users
  - Invite management (`AdminInviteApi`): create, list
  - Custom emoji management (`AdminEmojiApi`): add, update, delete, delete-bulk, list, list-remote, copy, import-zip, add/remove/set-aliases-bulk, set-category-bulk, set-license-bulk
  - Federation management (`AdminFederationApi`): delete-all-files, refresh-remote-instance-metadata, remove-all-following, update-instance
  - Relay management (`AdminRelaysApi`): add, list, remove
  - Abuse report management (`AdminAbuseReportsApi`): list, resolve, forward, update, notification-recipient list/show/create/update/delete
  - Announcement management (`AdminAnnouncementsApi`): create, list, update, delete
  - Job queue management (`AdminQueueApi`): stats, queues, queue-stats, jobs, show-job, show-job-logs, retry-job, remove-job, promote-jobs, clear, deliver-delayed, inbox-delayed
  - Drive management (`AdminDriveApi`): files, show-file, clean-remote-files, cleanup
  - Advertisement (`AdminAdApi`), avatar decoration (`AdminAvatarDecorationsApi`), system webhook (`AdminSystemWebhookApi`), and CAPTCHA configuration (`AdminCaptchaApi`)
- Admin models: `MisskeyAdminMeta` (typed subset + raw), `MisskeyAdminServerInfo`, `MisskeyAdminUserDetail` (with `MisskeySignin` / `MisskeyRoleAssign`), `MisskeyAdminCreatedAccount`, `MisskeyAbuseUserReport`, `MisskeyAbuseReportNotificationRecipient`, `MisskeyRelay`, `MisskeyAdminAnnouncement`, `MisskeyQueueStats`, `MisskeyQueueCount`, `MisskeyQueueInfo`, `MisskeyQueueMetrics`, `MisskeyQueueJob`, `MisskeyDelayedQueueEntry`, `MisskeyAd`, `MisskeyAdminAvatarDecoration`, `MisskeySystemWebhook`, `MisskeyCaptchaSettings`, `MisskeyModerationLog`, `MisskeyUserIp`, `MisskeyIndexStat`, `MisskeyTableStat`
- `httpClientAdapter` parameter on `MisskeyClient` to customize the HTTP transport (private CA trust, proxying)
- E2E test layer (`test/e2e/`) targeting the local closed-federation environment (`fediverse_e2e`); enabled via `RUN_E2E=1`, auto-skipped otherwise. Run it with `-j 1` — parallel suites hit the server's rate limit
- Tests covering the `unknownEnumValue` fallback for `MisskeyNoteVisibility`, `MisskeyOnlineStatus`, and `MisskeyNotificationType` when the server returns a value not yet known to this client
- Tests pinning `MisskeyUser.isAdmin` / `isModerator` in their `true` state, from an admin-scoped `users/show` fixture. Both fields default to `false`, so the previous general-user fixture could not distinguish a parsed `false` from an omitted field

### Changed

- **Breaking:** parameters changed to `Optional<T>` by the null-clearing fix below no longer accept a bare value. Wrap it: `description: 'text'` becomes `description: Optional('text')`. Affected so far: `ClipsApi.update()`, `ChannelsApi.update()`, `PagesApi.update()`
- **Breaking:** `MisskeyReactionAcceptance` gained an `unknown` member. Exhaustive `switch` statements over this enum in downstream code will no longer compile until the new member is handled
- Refreshed fixtures against a live, federated world (multi-account, cross-server posts/reactions/follows) via the fixture collection tool in `fediverse_e2e`, replacing the single-server March snapshot. Corresponding model tests were updated to assert on structural properties rather than hardcoded IDs/counts where the underlying data is inherently dynamic (timestamps, counters, federated content)

### Fixed

- Nullable fields could not be cleared by passing `null` to `update`-style methods (issue #12). Dart cannot distinguish an omitted optional parameter from an explicit `null`, so the naive `if (x != null)` guards these methods used dropped the field from the request body and the server treated the call as "no change". The affected parameters are now typed as `Optional<T>`, matching the methods that already used it. Fixed so far: `ClipsApi.update()` (`description`), `ChannelsApi.update()` (`description`, `bannerId`), `PagesApi.update()` (`summary`, `eyeCatchingImageId`)
- `MisskeyNote.reactionAcceptance` threw when the server returned a value not yet known to this client (no `unknownEnumValue` was configured), which would fail the deserialization of the entire note. Added a `MisskeyReactionAcceptance.unknown` fallback
- Model fields that the API documentation omits or mistypes, verified against a live Misskey 2026.5.1 server: queue counts include `paused` / `prioritized` / `waiting-children`; `QueueJob.failedReason` is absent for successful jobs; `QueueJob.progress` and `returnValue` are not objects; index stats include `schemaname` / `tablespace` / `indexdef`

### Notes

- `/channels/update` cannot clear `bannerId` on Misskey 2026.5.1. The server assembles its update object with `banner ? { bannerId: banner.id } : {}`, dropping an explicit `null`; sent alone the update object ends up empty and the server returns a 500 (`UpdateValuesMissingError`), sent alongside another parameter the call succeeds but the banner remains. `description` clears correctly. Documented on `ChannelsApi.update()` and pinned by E2E tests
- `/clips/update` always overwrites `description`: the server evaluates it as `description || null`, so omitting the parameter clears the existing value and an empty string is stored as `null`. This is server-side behaviour that the client cannot work around; pass the current value explicitly to preserve it. Documented on `ClipsApi.update()` and pinned by an E2E test
- `Meta.policies` / `MisskeyUser.policies` / `MisskeyRole.policies` already surface `canCreateChannel` (and any other server-added policy) through their dynamic `Map<String, dynamic>` representation, without needing a typed field — verified against Misskey 2026.5.1 and now covered by a fixture-based test


## [1.0.0-beta.1] - 2026-03-18

### Added

- Core HTTP client with Dio, automatic retry, and logging interceptor
- `MisskeyClientConfig` for base URL, timeout, User-Agent, headers, retry, and log configuration
- `TokenProvider` supporting synchronous and asynchronous token retrieval
- `AuthMode` enum (required, optional, none) for per-request authentication control
- `Optional<T>` sealed type distinguishing "not specified" from "explicitly send null"
- Sealed exception hierarchy (`MisskeyClientException`) mapping HTTP status codes (401, 403, 404, 422, 429, 5xx) and network errors
- Customizable logging via `Logger` interface with `StdoutLogger` and `FunctionLogger` implementations
- Account API: profile fetch/update, pin/unpin, favorites, password/email/token management, sign-in history, account move/delete, export/import (notes, following, blocking, muting, antennas, clips, user lists), gallery posts/likes, authorized apps
- Account sub-APIs: registry (key-value storage), two-factor authentication (TOTP/security key), webhooks CRUD
- Notes API: list, show, create (with text, CW, files, polls, visibility, scheduled posts), delete, timelines (home, local, hybrid, global, user list, channel), reactions, renotes, replies, children, conversation, featured, mentions, search (full-text and hashtag), favorites, drafts (CRUD and count), translation, partial bulk fetch
- Users API: fetch by ID/username/multiple, directory listing, followers/following, user notes, search, user list CRUD with membership management
- Notifications API: list, grouped list, mark all as read, flush, create custom notifications, test notification
- Following API: follow, unfollow, update per-follow settings, bulk update, invalidate follower
- Follow requests API: list received/sent, accept, reject, cancel
- Blocking API: block, unblock, list
- Mute API: mute (with optional expiration), unmute, list
- Renote mute API: mute/unmute renotes only, list
- Channels API: CRUD, timeline, follow/unfollow, favorite/unfavorite, search, featured/followed/owned listing, channel mute CRUD
- Antennas API: CRUD, notes listing with keyword/user/list source filtering
- Chat API: history, read all, direct messages (create/delete/show/react/search/timeline), rooms (CRUD/join/leave/mute/members/invitations)
- Clips API: CRUD, add/remove notes, notes listing, favorite/unfavorite
- Drive API: file CRUD (upload with progress, URL upload, show by ID/URL, update, delete), folder CRUD, stats (capacity info), stream, find by hash, bulk move, attached notes
- Flash (Play) API: CRUD, featured, like/unlike, search
- Gallery API: featured, popular, posts listing, post CRUD, like/unlike
- Pages API: show by ID/name, featured, CRUD, like/unlike
- Federation API: instances listing with status filters, show instance, followers/following/users per host, stats, remote user refresh
- Meta API: server metadata with in-memory caching, `supports()` feature detection, server info, stats, ping, endpoints listing, custom emoji, pinned users, online users count, avatar decorations, retention
- Roles API: list public roles, show, notes, users
- Charts API: active users, AP requests, federation, instance, notes, users, per-user following/notes/page views/reactions
- Hashtags API: list, search, show, trends, users by hashtag
- Announcements API: list, show, mark as read
- Invite API: create, delete, remaining quota, list
- SW (Push) API: register, unregister, show registration, update registration
- ActivityPub API: resolve URI to user/note, fetch raw AP object
- `toJson()` method on all response models
- Docusaurus documentation site with 15 pages in 6 languages (English, Japanese, Chinese, German, French, Korean)
- GitHub Actions workflow for documentation deployment
- README in 6 languages

### Fixed

- `i/2fa/update-key` name parameter changed to optional

[1.0.0-beta.1]: https://github.com/LibraryLibrarian/misskey_client/releases/tag/v1.0.0-beta.1
