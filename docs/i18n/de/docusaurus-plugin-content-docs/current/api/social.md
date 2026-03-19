---
sidebar_position: 5
title: "Soziale Funktionen"
---

# Soziale Funktionen

Die sozialen APIs decken Folgebeziehungen, Folgeanfragen, Blockierungen und Stummschaltungen ab. Alle Operationen erfordern Authentifizierung.

## Folgen (`client.following`)

### Einem Benutzer folgen

```dart
final user = await client.following.create(userId: userId);
```

Wenn der Zielbenutzer eine Folgebestaetigung erfordert, wird eine Anfrage gesendet statt eines sofortigen Follows. Die Methode gibt den aktualisierten `MisskeyUser` zurueck.

Uebergeben Sie `withReplies: true`, um Antworten des gefolgten Benutzers in Ihrer Timeline einzuschliessen:

```dart
await client.following.create(userId: userId, withReplies: true);
```

### Entfolgen

```dart
await client.following.delete(userId: userId);
```

### Folgeeinstellungen aktualisieren

Benachrichtigungs- und Antwortanzeigeeinstellungen fuer eine einzelne Folgebeziehung aendern.

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' oder 'none'
  withReplies: true,
);
```

### Alle Follows gleichzeitig aktualisieren

Dieselben Einstellungen auf jedes Konto anwenden, dem Sie folgen. Anfragelimit: 10 Anfragen/Stunde.

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### Einen Follower entfernen

Entfernt jemanden zwangsweise, der Ihnen folgt.

```dart
await client.following.invalidate(userId: userId);
```

## Folgeanfragen (`client.following.requests`)

### Eingehende Anfragen

```dart
// Ausstehende an Sie gesendete Anfragen auflisten
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// Eine Anfrage annehmen
await client.following.requests.accept(userId: userId);

// Eine Anfrage ablehnen
await client.following.requests.reject(userId: userId);
```

### Ausgehende Anfragen

```dart
// Von Ihnen gesendete Anfragen auflisten
final sent = await client.following.requests.sent(limit: 20);

// Eine von Ihnen gesendete Anfrage abbrechen
await client.following.requests.cancel(userId: userId);
```

Alle Listen-Methoden akzeptieren `sinceId` / `untilId` und `sinceDate` / `untilDate` fuer die Seitennavigation.

## Blockieren (`client.blocking`)

Blockieren entfernt die gegenseitige Folgebeziehung zwischen Ihnen und dem Zielbenutzer. Ein blockierter Benutzer kann Ihnen nicht folgen, und Sie werden seinen Inhalt nicht sehen.

### Einen Benutzer blockieren

```dart
await client.blocking.create(userId: userId);
```

### Blockierung aufheben

```dart
await client.blocking.delete(userId: userId);
```

### Blockierte Benutzer auflisten

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

Seitennavigation mit `sinceId` / `untilId` oder `sinceDate` / `untilDate`.

## Stummschalten (`client.mute`)

Stummschalten blendet die Notizen, Renotes und Reaktionen eines Benutzers aus Ihrer Timeline aus. Anders als beim Blockieren weiss der Zielbenutzer nicht, dass er stummgeschaltet wurde.

### Einen Benutzer stummschalten

```dart
// Dauerhafte Stummschaltung
await client.mute.create(userId: userId);
```

### Zeitlich begrenzte Stummschaltung

Uebergeben Sie einen Unix-Zeitstempel in Millisekunden, um die Stummschaltung automatisch ablaufen zu lassen.

```dart
// 24 Stunden stummschalten
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### Stummschaltung aufheben

```dart
await client.mute.delete(userId: userId);
```

### Stummgeschaltete Benutzer auflisten

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## Renote-Stummschaltung (`client.renoteMute`)

Die Renote-Stummschaltung unterdrueckt nur die Renotes eines Benutzers aus Ihrer Timeline. Dessen urspruengliche Notizen bleiben sichtbar. Dies ist nuetzlich, wenn Sie dem originalen Inhalt einer Person folgen moechten, nicht jedoch dem weitergeleiteten Inhalt.

### Einen Benutzer fuer Renotes stummschalten

```dart
await client.renoteMute.create(userId: userId);
```

### Renote-Stummschaltung entfernen

```dart
await client.renoteMute.delete(userId: userId);
```

### Renote-stummgeschaltete Benutzer auflisten

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

Seitennavigation mit `sinceId` / `untilId` oder `sinceDate` / `untilDate`.

## Vergleich: Stummschalten vs. Renote-Stummschalten

| | Normale Stummschaltung | Renote-Stummschaltung |
|---|---|---|
| Urspruengliche Notizen ausgeblendet | Ja | Nein |
| Renotes ausgeblendet | Ja | Ja |
| Zielbenutzer benachrichtigt | Nein | Nein |
| Zeitlich begrenzte Ablaufzeit | Ja | Nein |
