---
sidebar_position: 1
slug: /
title: Erste Schritte
---

# Erste Schritte

:::warning Beta

Diese Bibliothek befindet sich derzeit im **Beta**-Stadium. Die API-Implementierung ist abgeschlossen, die Testabdeckung ist jedoch minimal. Response-Modelle und Methodensignaturen können sich auf Basis von Testergebnissen ändern.

Falls Sie fehlerhafte Response-Modelle oder unerwartetes Verhalten feststellen, melden Sie dies bitte über [GitHub Issues](https://github.com/LibraryLibrarian/misskey_client/issues) oder reichen Sie einen [Pull Request](https://github.com/LibraryLibrarian/misskey_client/pulls) ein.

:::

misskey_client ist eine reine Dart-Bibliothek als Misskey-API-Client.
Sie funktioniert in jeder Umgebung, in der Dart lauffähig ist: Flutter, serverseitiges Dart, CLI-Tools und mehr.

## Installation

Fuegen Sie die Abhaengigkeit in Ihre `pubspec.yaml` ein:

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
```

Anschliessend laden Sie das Paket herunter:

```bash
dart pub get
```

## Grundlegende Verwendung

### Client initialisieren

```dart
import 'package:misskey_client/misskey_client.dart';

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` muss ein `Uri` sein, der das Schema enthaelt (z. B. `https://`).
`tokenProvider` ist ein Callback, der `FutureOr<String?>` zurueckgibt. Er kann weggelassen werden, wenn nur Endpunkte verwendet werden, die keine Authentifizierung erfordern.

### Ihr erster API-Aufruf

Abruf von Serverinformationen (keine Authentifizierung erforderlich):

```dart
final serverInfo = await client.meta.fetch();
print(serverInfo.name);        // Servername
print(serverInfo.description); // Serverbeschreibung
```

Abruf des eigenen Kontos des authentifizierten Benutzers:

```dart
final me = await client.account.i();
print(me.name);     // Anzeigename
print(me.username); // Benutzername (ohne @)
```

### API-Struktur

Jede API-Domaene ist als Eigenschaft auf `MisskeyClient` zugaenglich:

```dart
client.account       // Konto- und Profielverwaltung (/api/i/*)
client.announcements // Serverankuendigungen
client.antennas      // Antennenverwaltung (Schluesselwort-Monitoring)
client.ap            // ActivityPub-Endpunkte
client.blocking      // Benutzer blockieren
client.channels      // Kanalverwaltung
client.charts        // Statistikdiagramme
client.chat          // Direktnachrichten
client.clips         // Notiz-Clip-Verwaltung
client.drive         // Dateispeicher (drive.files, drive.folders, drive.stats)
client.federation    // Informationen zu foederierten Instanzen
client.flash         // Play (Flash)-Verwaltung
client.following     // Folgen / Entfolgen
client.gallery       // Galerie-Beitrageverwaltung
client.hashtags      // Hashtag-Informationen
client.invite        // Einladungscodeverwaltung
client.meta          // Server-Metadaten
client.mute          // Benutzer stummschalten
client.notes         // Notizoperationen (Timelines, erstellen, reagieren usw.)
client.notifications // Benachrichtigungen abrufen und verwalten
client.pages         // Seitenverwaltung
client.renoteMute    // Renote-Stummschaltungsverwaltung
client.roles         // Rollenverwaltung
client.sw            // Service Worker Push-Benachrichtigungsregistrierung
client.users         // Benutzersuche, Folgelisten, Benutzerlisten
```

### Log-Ausgabe steuern

HTTP-Anfrage-/Antwortprotokolle sind standardmaessig deaktiviert. Sie koennen ueber `MisskeyClientConfig` aktiviert werden:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

Um Protokolle an eine eigene Ausgabe weiterzuleiten, uebergeben Sie eine `Logger`-Implementierung an den Konstruktor:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level ist einer von: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

Weitere Informationen finden Sie unter [Logging](./advanced/logging.md).

## Naechste Schritte

- [Authentifizierung](./authentication.md) — Token-basierte Authentifizierung und MiAuth-Ablauf
- [Fehlerbehandlung](./error-handling.md) — Ausnahmehierarchie und Abfangmuster
- [Notizen](./api/notes.md) — Notizen erstellen und abrufen
- [Drive-Upload](./advanced/drive-upload.md) — Dateien in Drive hochladen
