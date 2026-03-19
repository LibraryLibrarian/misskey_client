# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
