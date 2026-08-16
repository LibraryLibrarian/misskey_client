[English](README.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | Deutsch | [Français](README.fr.md) | [한국어](README.ko.md)

# misskey_client

Eine reine Dart-Clientbibliothek für die [Misskey](https://misskey-hub.net/) API. Bietet typisierten Zugriff auf 25 API-Domänen mit integrierter Authentifizierung, Wiederholungslogik und strukturierter Fehlerbehandlung.

> **Beta**: Die API-Implementierung ist abgeschlossen, die Testabdeckung ist jedoch minimal. Response-Modelle und Methodensignaturen können sich auf Basis von Testergebnissen ändern. Siehe [CHANGELOG](CHANGELOG.md) für Details.

## Funktionen

- Abdeckung von 25 Misskey-API-Domänen (Notes, Drive, Benutzer, Channels, Chat und mehr)
- Token-basierte Authentifizierung über einen austauschbaren `TokenProvider`-Callback
- Automatische Wiederholung mit konfigurierbarer maximaler Anzahl von Versuchen
- Versiegelte Ausnahmeklassenhierarchie für erschöpfende Fehlerbehandlung
- Stark typisierte Anfrage- und Antwortmodelle, generiert mit `json_serializable`
- Integrierte Streaming API mit typisierten Channels, Events und automatischer Wiederverbindung
- Konfigurierbares Logging über ein austauschbares `Logger`-Interface
- Reines Dart — keine Flutter-Abhängigkeit erforderlich

## Installation

Fügen Sie das Paket zu Ihrer `pubspec.yaml` hinzu:

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.6
```

Führen Sie anschließend aus:

```
dart pub get
```

## Schnellstart

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // Geben Sie Ihr Zugriffstoken an. Der Callback kann asynchron sein.
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // Notes der authentifizierten Benutzerin abrufen
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## API-Übersicht

`MisskeyClient` stellt die folgenden Eigenschaften bereit, die jeweils einen eigenen Bereich der Misskey API abdecken:

| Eigenschaft | Beschreibung |
|---|---|
| `account` | Konto- und Profilverwaltung, Registry, 2FA, Webhooks |
| `announcements` | Server-Ankündigungen |
| `antennas` | Antennen-Verwaltung (stichwortbasierte Feeds) |
| `ap` | ActivityPub-Hilfsfunktionen |
| `blocking` | Benutzer blockieren |
| `channels` | Channels und Channel-Stummschaltungen |
| `charts` | Statistik-Charts |
| `chat` | Chat-Räume und Nachrichten |
| `clips` | Clip-Sammlungen |
| `drive` | Drive (Dateispeicher), Dateien, Ordner, Statistiken |
| `federation` | Informationen zu föderierten Instanzen |
| `flash` | Flash (Play)-Skripte |
| `following` | Folgen und Folgeanfragen |
| `gallery` | Galerie-Beiträge |
| `hashtags` | Hashtag-Suche und Trends |
| `invite` | Einladungscodes |
| `meta` | Server-Metadaten |
| `mute` | Benutzer stummschalten |
| `notes` | Notes, Reactions, Abstimmungen, Suche, Timeline |
| `notifications` | Benachrichtigungen |
| `pages` | Seiten |
| `renoteMute` | Renote-Stummschaltungen |
| `roles` | Rollenzuweisungen |
| `sw` | Push-Benachrichtigungen (Service Worker) |
| `streaming` | Echtzeit-Timelines, Benachrichtigungen und Updates erfasster Notes |
| `users` | Benutzersuche, Listen, Beziehungen, Erfolge |

## Streaming API

Die verzögert erstellte Verbindung `client.streaming` verwendet Server, Token-Provider und Logger des Clients gemeinsam. Abonnieren Sie einen typisierten `MisskeyStreamingChannel` und wählen Sie die passende Ebene: dekodierte `notes` und `notifications`, typisierte `events` oder verlustfreie `messages`.

```dart
Future<void> streamHomeTimeline() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
    ),
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
    streamingConfig: MisskeyStreamingConfig(maxReconnectAttempts: 5),
  );

  await client.streaming.connect();
  final home = await client.streaming.subscribe(
    const MisskeyStreamingChannel.homeTimeline(
      withRenotes: true,
      withFiles: false,
    ),
  );

  final notesSubscription = home.notes.listen((note) {
    print(note.text);
  });
  final eventsSubscription = home.events.listen((event) {
    if (event is MisskeyNoteReactedEvent) {
      print('${event.noteId}: ${event.reaction}');
    }
  });

  // Bekannte Note erfassen, um Reaction-, Lösch- und Abstimmungsupdates zu empfangen.
  home.captureNote('NOTE_ID');

  await notesSubscription.cancel();
  await eventsSubscription.cancel();
  home.uncaptureNote('NOTE_ID');
  await home.unsubscribe();
  await client.dispose();
}
```

Verwenden Sie `subscribeRaw(channel: ..., params: ...)` für Fork-spezifische Channels. Die Methode liefert denselben Subscription-Handle einschließlich des `messages`-Streams. `connect()`, `disconnect()` und `reconnect()` steuern eine wiederverwendbare Verbindung; `dispose()` beendet sie dauerhaft. Verbindungszustände stehen über `state` und `stateChanges` zur Verfügung, asynchrone Fehler über `errors`.

## Authentifizierung

Übergeben Sie beim Erstellen des Clients einen `TokenProvider`-Callback. Der Callback gibt `FutureOr<String?>` zurück, sodass sowohl synchrone als auch asynchrone Token-Quellen unterstützt werden:

```dart
// Synchrones Token
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// Asynchrones Token
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

Endpunkte, die eine Authentifizierung erfordern, fügen das Token automatisch hinzu. Endpunkte mit optionaler Authentifizierung hängen das Token an, wenn eines verfügbar ist.

## Fehlerbehandlung

Alle Ausnahmen erweitern die versiegelte Klasse `MisskeyClientException`, was erschöpfendes Pattern Matching ermöglicht:

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — Token ungültig oder fehlend
} on MisskeyForbiddenException {
  // 403 — Vorgang nicht erlaubt
} on MisskeyNotFoundException {
  // 404 — Ressource nicht gefunden
} on MisskeyRateLimitException catch (e) {
  // 429 — Rate-Limit überschritten; e.retryAfter prüfen
} on MisskeyValidationException {
  // 422 — Ungültiger Anfragekörper
} on MisskeyServerException {
  // 5xx — Serverseitiger Fehler
} on MisskeyNetworkException {
  // Timeout, Verbindung abgelehnt, usw.
}
```

## Logging

Aktivieren Sie den integrierten stdout-Logger über `MisskeyClientConfig.enableLog`, oder übergeben Sie eine eigene `Logger`-Implementierung:

```dart
class MyLogger implements Logger {
  @override void debug(String message) { /* ... */ }
  @override void info(String message)  { /* ... */ }
  @override void warn(String message)  { /* ... */ }
  @override void error(String message, [Object? error, StackTrace? stackTrace]) { /* ... */ }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(baseUrl: Uri.parse('https://misskey.example.com')),
  logger: MyLogger(),
);
```

## Migration von misskey_api_core

### API-Zuordnung

| misskey_api_core | misskey_client |
|---|---|
| `MisskeyHttpClient(config: ..., tokenProvider: ...)` | `MisskeyClient(config: ..., tokenProvider: ...)` |
| `MisskeyApiConfig(baseUrl: ...)` | `MisskeyClientConfig(baseUrl: ...)` |
| `http.send<T>('/emojis', ...)` | Die entsprechende typisierte Methode, z. B. `client.meta.getEmojis()` |
| `MetaClient(http).getMeta()` | `client.meta.getMeta()` |
| `MisskeyApiException` | Die versiegelte Hierarchie mit `MisskeyApiException`, `MisskeyUnauthorizedException`, `MisskeyForbiddenException`, `MisskeyRateLimitException` und weiteren |
| `RequestOptions(authRequired: false)` | Wird intern von typisierten Methoden verarbeitet; aufrufender Code muss nichts angeben |
| `Logger` / `FunctionLogger` | Klassen mit denselben Namen |
| `kReleaseMode` / `kDebugMode` | Nicht Teil der öffentlichen API; siehe unten |

### Namenskonflikt bei MisskeyApiException

Beide Pakete definieren `MisskeyApiException`, die Klassen haben jedoch unterschiedliche Inhalte und keine Vererbungsbeziehung. Die Variante aus `misskey_api_core` ist eine einfache Klasse, während die Variante aus `misskey_client` von `MisskeyClientException` erbt und einen `statusCode` erfordert. Wenn während der Migration beide Pakete importiert werden, verhindert ein Präfix den Konflikt:

```dart
import 'package:misskey_api_core/misskey_api_core.dart' as core;
```

### Konstanten für den Build-Modus

`misskey_api_core` exportierte `kReleaseMode` und `kDebugMode`; `misskey_client` nimmt sie nicht in seine öffentliche API auf. Es handelt sich um allgemeine Hilfsfunktionen ohne Bezug zu Misskey. Flutter-Anwendungen sollten die Konstanten aus `package:flutter/foundation.dart` verwenden; reine Dart-Anwendungen können `bool.fromEnvironment('dart.vm.product')` nutzen. Steuern Sie das Client-Logging über `MisskeyClientConfig.enableLog`, zum Beispiel mit `enableLog: kDebugMode`.

### Low-Level-HTTP-Zugriff

Das Low-Level-Gegenstück zu `MisskeyHttpClient.send<T>()` ist nicht öffentlich. `misskey_client` deckt 25 API-Domänen ab; verwenden Sie daher die typisierten Methoden. Falls ein benötigter Endpunkt fehlt, melden Sie ihn bitte in einem GitHub-Issue, damit er der typisierten API hinzugefügt werden kann.

## Migration von misskey_streaming

Streaming ist jetzt in `misskey_client` integriert. Der [Migrationsleitfaden](MIGRATION_FROM_MISSKEY_STREAMING.md) beschreibt die Zuordnung von Abhängigkeiten, Konfiguration, Subscriptions, Events, Note-Erfassung und Lebenszyklus aus dem eigenständigen Paket `misskey_streaming`.

## Dokumentation

- API-Referenz: https://librarylibrarian.github.io/misskey_client/
- pub.dev-Seite: https://pub.dev/packages/misskey_client
- GitHub: https://github.com/LibraryLibrarian/misskey_client

## Lizenz

Siehe [LICENSE](LICENSE).
