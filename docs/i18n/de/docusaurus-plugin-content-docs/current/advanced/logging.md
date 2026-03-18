---
sidebar_position: 1
title: Logging
---

# Logging

misskey_client kann HTTP-Anfragen und -Antworten protokollieren. Die Protokollierung ist standardmaessig deaktiviert.

## Protokollierung aktivieren

Setzen Sie `enableLog: true` in `MisskeyClientConfig`:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

Wenn aktiviert, schreibt der Standard-`StdoutLogger` ueber das `logger`-Paket nach stdout.

## Protokollierung deaktivieren

Lassen Sie `enableLog` weg oder setzen Sie es auf `false` (Standard):

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: false, // Standard
  ),
);
```

## Benutzerdefinierter Logger mit FunctionLogger

`FunctionLogger` passt einen einfachen Callback an das `Logger`-Interface an:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level ist einer von: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

`FunctionLogger` hat Vorrang vor dem `enableLog`-Flag. Wenn Sie einen benutzerdefinierten Logger angeben, empfaengt er alle Protokollaufrufe unabhaengig von `enableLog`.

## Einen benutzerdefinierten Logger implementieren

Fuer vollstaendige Kontrolle implementieren Sie das `Logger`-Interface:

```dart
class MyLogger implements Logger {
  @override
  void debug(String message) { /* ... */ }

  @override
  void info(String message) { /* ... */ }

  @override
  void warn(String message) { /* ... */ }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Fehler mit optionalem Stack-Trace behandeln
  }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: MyLogger(),
);
```

## Standardverhalten

Wenn `enableLog: true` gesetzt ist und kein benutzerdefinierter `logger` angegeben wurde, wird der `StdoutLogger` verwendet. Dieser delegiert intern an das `logger`-Paket.

In Debug-Builds werden alle Protokollebenen (Debug und hoeher) ausgegeben. In Release-Builds werden nur Warnungen und Fehler ausgegeben.

Protokollformat:

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
