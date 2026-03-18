---
sidebar_position: 5
title: "Social"
---

# Social

Les API sociales couvrent les relations d'abonnement, les demandes d'abonnement, les blocages et les mises en sourdine. Toutes les opérations nécessitent une authentification.

## Abonnements (`client.following`)

### S'abonner à un utilisateur

```dart
final user = await client.following.create(userId: userId);
```

Si l'utilisateur cible nécessite une approbation, une demande est envoyée au lieu d'un abonnement immédiat. La méthode retourne le `MisskeyUser` mis à jour.

Passez `withReplies: true` pour inclure les réponses de l'utilisateur suivi dans votre fil d'actualité :

```dart
await client.following.create(userId: userId, withReplies: true);
```

### Se désabonner

```dart
await client.following.delete(userId: userId);
```

### Mettre à jour les paramètres d'abonnement

Modifiez les paramètres de notification et d'affichage des réponses pour une relation d'abonnement individuelle.

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' or 'none'
  withReplies: true,
);
```

### Mettre à jour tous les abonnements à la fois

Appliquez les mêmes paramètres à tous les comptes que vous suivez. Limite de débit : 10 requêtes/heure.

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### Supprimer un abonné

Supprime de force quelqu'un qui vous suit.

```dart
await client.following.invalidate(userId: userId);
```

## Demandes d'abonnement (`client.following.requests`)

### Demandes entrantes

```dart
// List pending requests sent to you
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// Accept a request
await client.following.requests.accept(userId: userId);

// Reject a request
await client.following.requests.reject(userId: userId);
```

### Demandes sortantes

```dart
// List requests you have sent
final sent = await client.following.requests.sent(limit: 20);

// Cancel a request you sent
await client.following.requests.cancel(userId: userId);
```

Toutes les méthodes de liste acceptent `sinceId` / `untilId` et `sinceDate` / `untilDate` pour la pagination.

## Blocage (`client.blocking`)

Le blocage supprime la relation d'abonnement mutuel entre vous et la cible. Un utilisateur bloqué ne peut pas vous suivre et vous ne verrez pas son contenu.

### Bloquer un utilisateur

```dart
await client.blocking.create(userId: userId);
```

### Débloquer

```dart
await client.blocking.delete(userId: userId);
```

### Lister les utilisateurs bloqués

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

Paginez avec `sinceId` / `untilId` ou `sinceDate` / `untilDate`.

## Mise en sourdine (`client.mute`)

La mise en sourdine masque les notes, renotes et réactions d'un utilisateur dans votre fil d'actualité. Contrairement au blocage, l'utilisateur cible ignore qu'il a été mis en sourdine.

### Mettre un utilisateur en sourdine

```dart
// Permanent mute
await client.mute.create(userId: userId);
```

### Mise en sourdine temporaire

Passez un horodatage Unix en millisecondes pour que la mise en sourdine expire automatiquement.

```dart
// Mute for 24 hours
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### Rétablir le son

```dart
await client.mute.delete(userId: userId);
```

### Lister les utilisateurs mis en sourdine

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## Mise en sourdine des renotes (`client.renoteMute`)

La mise en sourdine des renotes supprime uniquement les renotes d'un utilisateur de votre fil d'actualité. Ses notes originales restent visibles. C'est utile lorsque vous souhaitez suivre le contenu original d'un utilisateur mais pas son contenu reposté.

### Mettre en sourdine les renotes d'un utilisateur

```dart
await client.renoteMute.create(userId: userId);
```

### Supprimer une mise en sourdine de renote

```dart
await client.renoteMute.delete(userId: userId);
```

### Lister les utilisateurs dont les renotes sont mises en sourdine

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

Paginez avec `sinceId` / `untilId` ou `sinceDate` / `untilDate`.

## Comparaison : mise en sourdine standard et mise en sourdine des renotes

| | Mise en sourdine standard | Mise en sourdine des renotes |
|---|---|---|
| Notes originales masquées | Oui | Non |
| Renotes masquées | Oui | Oui |
| Cible notifiée | Non | Non |
| Expiration temporelle | Oui | Non |
