# Endpoint support policy

`misskey_client` prioritizes typed APIs that are useful to general-purpose
Misskey applications. Endpoint presence in the upstream schema does not by
itself mean that an endpoint belongs in this package.

## Account lifecycle and admin emoji v2

The unauthenticated account lifecycle endpoints are available through
`MisskeyClient.accountLifecycle`:

- `username/available`
- `email-address/available`
- `request-reset-password`
- `reset-password`
- `verify-email`

The successor admin emoji search endpoint, `v2/admin/emoji/list`, is available
through `MisskeyClient.adminEmoji.listV2`. It requires a credential with the
upstream `canManageCustomEmojis` role policy.

## Deliberately unsupported endpoints

The Reversi and Bubble Game endpoints are outside the package scope. Reversi
requires its dedicated streaming channels and game lifecycle, while neither
game is needed by the applications this package currently supports.

The upstream `test` and `reset-db` endpoints are also unsupported. They are
server-internal or test-environment operations; `reset-db` is available only
when the server runs with `NODE_ENV=test`. They must not be exposed as normal
client-library operations.

## Deferred endpoint groups

Legacy app/session authentication (`app/*`, `auth/session/*`, `auth/accept`,
`miauth/gen-token`, and `my/apps`) is deferred. Supporting that flow requires a
coordinated decision with the separate `misskey_auth` package and is not
equivalent to saying those endpoints can never be supported.

The remaining utility endpoints (`fetch-rss`, `fetch-external-resources`,
`export-custom-emojis`, `promo/read`, and `page-push`) are deferred as
specialized or low-priority APIs. They may be added later when a concrete typed
consumer and ownership boundary are established.
