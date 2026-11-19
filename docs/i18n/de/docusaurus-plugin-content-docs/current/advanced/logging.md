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

Ein benutzerdefinierter Logger ersetzt den Standard-`StdoutLogger`, umgeht `enableLog` jedoch nicht: Er empfaengt Protokollaufrufe nur, solange `enableLog` auf `true` gesetzt ist.

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
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: MyLogger(),
);
```

## Standardverhalten

Wenn `enableLog: true` gesetzt ist und kein benutzerdefinierter `logger` angegeben wurde, wird der `StdoutLogger` verwendet. Dieser delegiert intern an das `logger`-Paket.

Protokolle zu HTTP-Anfragen, -Antworten und Wiederholungsversuchen werden nur ausgegeben, wenn `enableLog` auf `true` gesetzt ist und es sich nicht um einen Release-Build handelt. Der Standard-`StdoutLogger` verwendet den Entwicklungsfilter des `logger`-Pakets, der bei deaktivierten Assertions (wie in Release-Builds) alle Ausgaben unterdrueckt. Streaming-Protokollaufrufe haengen nur von `enableLog` ab, sodass ein benutzerdefinierter Logger sie auch in Release-Builds empfangen kann.

Protokollformat:

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
