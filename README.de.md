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
- Konfigurierbares Logging über ein austauschbares `Logger`-Interface
- Reines Dart — keine Flutter-Abhängigkeit erforderlich

## Installation

Fügen Sie das Paket zu Ihrer `pubspec.yaml` hinzu:

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
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
| `users` | Benutzersuche, Listen, Beziehungen, Erfolge |

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

## Dokumentation

- API-Referenz: https://librarylibrarian.github.io/misskey_client/
- pub.dev-Seite: https://pub.dev/packages/misskey_client
- GitHub: https://github.com/LibraryLibrarian/misskey_client

## Lizenz

Siehe [LICENSE](LICENSE).
