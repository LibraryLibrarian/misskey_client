---
sidebar_position: 2
title: Authentifizierung
---

# Authentifizierung

Misskey verwendet tokenbasierte Authentifizierung. Ein geheimes Token (in der Misskey-API als `i` bezeichnet) wird in jeden authentifizierten POST-Anfrage-Body eingefuegt. Anders als bei OAuth-basierten APIs gibt es keinen Bearer-Header — das Token wird im JSON-Body uebertragen.

## Funktionsweise von TokenProvider

`TokenProvider` ist ein Typedef fuer einen Callback, der `FutureOr<String?>` zurueckgibt:

```dart
typedef TokenProvider = FutureOr<String?> Function();
```

Der Callback wird fuer jede authentifizierte Anfrage aufgerufen. Dieses Design ermoeglicht es, Tokens zu aktualisieren oder verzoegert zu laden, ohne den Client neu aufzubauen.

### Synchrones Token

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_token_here',
);
```

### Asynchrones Token (z. B. aus sicherem Speicher geladen)

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () async {
    return await secureStorage.read(key: 'misskey_token');
  },
);
```

### Token-Aktualisierungsmuster

Wenn Ihr Token rotiert werden kann, geben Sie den aktuellen Wert vom Provider zurueck. Der Client ruft den Callback unmittelbar vor dem Senden auf, daher genuegt es, einen aktuellen Wert zurueckzugeben:

```dart
String? _cachedToken;

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => _cachedToken,
);

// Aktualisieren Sie den zwischengespeicherten Wert, wenn sich das Token aendert.
void onTokenRefreshed(String newToken) {
  _cachedToken = newToken;
}
```

## AuthMode-Enum

Jeder API-Endpunkt deklariert seine Authentifizierungsanforderung mithilfe des `AuthMode`-Enums:

| Modus | Verhalten |
|-------|-----------|
| `AuthMode.required` | Token wird eingefuegt; wirft eine Ausnahme, wenn keins angegeben ist (Standard) |
| `AuthMode.optional` | Token wird eingefuegt, wenn vorhanden; Anfrage wird auch ohne Token ausgefuehrt |
| `AuthMode.none` | Token wird niemals eingefuegt, unabhaengig vom Provider |

Dies ist eine interne Bibliotheksangelegenheit. Als Verwender muessen Sie lediglich `tokenProvider` angeben. Die Bibliothek uebernimmt die Einfuegung automatisch.

Endpunkte mit `AuthMode.optional` liefern reichhaltigere Antworten bei authentifizierten Anfragen. Beispielsweise enthaelt `notes/show` die Felder `myReaction` und `isFavorited` nur, wenn ein Token vorhanden ist.

## Token erhalten: MiAuth-Ablauf

Misskey verwendet kein OAuth 2.0. Der empfohlene Ablauf fuer Drittanbieter-Apps ist **MiAuth**, ein vereinfachter Browser-Redirect-Ablauf.

```
1. Eine Sitzungs-UUID generieren
2. Die MiAuth-URL im Browser oeffnen
3. Benutzer erteilt die Berechtigung in der Misskey-Weboberflaeche
4. Weiterleitung erfolgt zur Callback-URL (oder Sie fragen die API ab)
5. Die Sitzungs-UUID gegen ein Token eintauschen
```

### Schritt 1: Autorisierungs-URL erstellen

```dart
import 'package:uuid/uuid.dart';

final session = const Uuid().v4();
final baseUrl = 'https://misskey.example.com';

final authUrl = Uri.parse('$baseUrl/miauth/$session').replace(
  queryParameters: {
    'name': 'My App',
    'callback': 'myapp://auth/callback',
    'permission': 'read:account,write:notes',
  },
);
// authUrl im Browser oder WebView oeffnen
```

### Schritt 2: Sitzung gegen Token eintauschen

Nachdem der Benutzer die Anfrage genehmigt hat, rufen Sie den Check-Endpunkt auf. Dies ist ein einfaches HTTP-GET und verwendet nicht den authentifizierten Pfad der Bibliothek:

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/miauth/$session/check'),
);
final json = jsonDecode(response.body) as Map<String, dynamic>;
final token = json['token'] as String?;
```

Speichern Sie das Token sicher und uebergeben Sie es an `tokenProvider`.

## Nicht authentifizierte Verwendung

Uebergeben Sie keinen `tokenProvider`, um auf oeffentliche Endpunkte zuzugreifen:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
);

// Funktioniert ohne Token
final info = await client.meta.fetch();
final notes = await client.notes.timelineLocal(limit: 10);
```

Der Aufruf eines Endpunkts mit `AuthMode.required` ohne Provider wirft eine `MisskeyUnauthorizedException`.
