---
sidebar_position: 4
title: "Konto & Profil"
---

# Konto & Profil

Die `client.account`-API bietet Operationen fuer den aktuell authentifizierten Benutzer — Abrufen und Aktualisieren von Profilinformationen, Verwalten von Anmeldedaten, Exportieren/Importieren von Daten sowie Zugriff auf Unter-APIs fuer die Registry, Zwei-Faktor-Authentifizierung und Webhooks.

## Eigenes Profil abrufen

```dart
final me = await client.account.i();
print(me.name);        // Anzeigename
print(me.username);    // Benutzername (ohne @)
print(me.description); // Profiltext
```

## Eigenes Profil aktualisieren

`update` akzeptiert jede Kombination von Feldern. Es werden nur die Felder an den Server gesendet, die Sie angeben; ausgelassene Felder bleiben unveraendert und der aktualisierte `MisskeyUser` wird zurueckgegeben.

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('en'),
  isLocked: false,
);
```

### Der Optional-Typ

Felder, die der Server als `null` akzeptieren kann (um den Wert zu loeschen), verwenden den `Optional<T>`-Wrapper. Damit kann die Bibliothek zwischen drei Zustaenden unterscheiden:

- Parameter weggelassen — Feld ist nicht in der Anfrage enthalten; Serverwert unveraendert.
- `Optional('value')` — Feld wird auf den angegebenen Wert gesetzt.
- `Optional.null_()` — Feld wird explizit geloescht.

```dart
// Avatar auf eine Drive-Datei setzen und Geburtstag loeschen
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### Datenschutz und Sichtbarkeit

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public', 'followers' oder 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,                   // Folgebestaetigung erforderlich
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## Notizen anpinnen und losloesen

```dart
// Eine Notiz an Ihr Profil anpinnen
final updated = await client.account.pin(noteId: noteId);

// Notiz losloesen
final updated = await client.account.unpin(noteId: noteId);
```

Beide Methoden geben den aktualisierten `MisskeyUser` zurueck.

## Favoriten

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note?.text);
}
```

Seitennavigation mit `sinceId` / `untilId` oder `sinceDate` / `untilDate` (Unix-Zeitstempel in Millisekunden).

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## Passwort, E-Mail und Token-Verwaltung

### Passwort aendern

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

Wenn die Zwei-Faktor-Authentifizierung aktiviert ist, uebergeben Sie den aktuellen TOTP-Code als `token`.

### E-Mail-Adresse aktualisieren

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// E-Mail-Adresse entfernen
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### API-Token neu generieren

Das aktuelle Token wird unmittelbar nach Abschluss des Aufrufs ungueltig.

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### Ein Token widerrufen

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

## Export und Import

Alle Exportvorgaenge werden als asynchrone Jobs in die Warteschlange gestellt. Bei Abschluss wird eine Benachrichtigung gesendet.

### Daten exportieren

```dart
await client.account.exportNotes();
await client.account.exportFollowing(excludeMuting: true, excludeInactive: true);
await client.account.exportBlocking();
await client.account.exportMute();
await client.account.exportFavorites();
await client.account.exportAntennas();
await client.account.exportClips();
await client.account.exportUserLists();
```

### Daten importieren

Uebergeben Sie die Drive-Datei-ID der zuvor exportierten Datei.

```dart
// Datei zuerst in das Drive hochladen, dann die ID uebergeben
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## Anmeldeverlauf

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## Unter-APIs

`AccountApi` stellt drei Unter-APIs als Eigenschaften bereit.

### Registry

Die Registry speichert beliebige Schluessel-Wert-Daten fuer Client-Anwendungen (entspricht dem Browser-localStorage, aber geraeteuebergreifend synchronisiert).

Wenn Sie mit `registry.set` den Wert `null` speichern, gibt `registry.get` den Wert `null` zurueck. Eine gespeicherte leere Zeichenfolge wird als leere Zeichenfolge zurueckgegeben.

```dart
// Einen Wert lesen
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// Einen Wert schreiben
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### Zwei-Faktor-Authentifizierung

```dart
// TOTP-Registrierung beginnen
final reg = await client.account.twoFactor.register(password: 'mypassword');
final qr = reg.qr ?? generateQrDataUrl(reg.url);
print(qr); // QR-Code-Daten-URL zur Anzeige in der Benutzeroberflaeche

// TOTP mit dem ersten Code der Authenticator-App bestaetigen und aktivieren
await client.account.twoFactor.done(token: '123456');
```

Ab Misskey 2026.11.0 wird `qr` nicht mehr zurueckgegeben. In diesem Beispiel ist `generateQrDataUrl` eine von Ihrer Anwendung bereitgestellte Funktion, die die `otpauth`-URL in `reg.url` mit einer QR-Code-Bibliothek in eine QR-Bild-Daten-URL umwandelt.

### Webhooks

```dart
// Einen Webhook erstellen
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// Webhooks auflisten
final webhooks = await client.account.webhooks.list();
```
