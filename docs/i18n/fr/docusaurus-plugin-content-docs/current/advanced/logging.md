---
sidebar_position: 1
title: Journalisation
---

# Journalisation

misskey_client peut journaliser les requêtes et réponses HTTP. La journalisation est désactivée par défaut.

## Activer les journaux

Définissez `enableLog: true` dans `MisskeyClientConfig` :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

Lorsqu'elle est activée, le `StdoutLogger` par défaut écrit vers stdout via le package `logger`.

## Désactiver les journaux

Omettez `enableLog` ou définissez-le à `false` (valeur par défaut) :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: false, // default
  ),
);
```

## Logger personnalisé avec FunctionLogger

`FunctionLogger` adapte un simple rappel à l'interface `Logger` :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level is one of: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

`FunctionLogger` a priorité sur l'indicateur `enableLog`. Si vous fournissez un logger personnalisé, il reçoit tous les appels de journalisation quelle que soit la valeur de `enableLog`.

## Implémenter un Logger personnalisé

Pour un contrôle total, implémentez l'interface `Logger` :

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
    // Handle error with optional stack trace
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

## Comportement par défaut

Lorsque `enableLog: true` est défini et qu'aucun `logger` personnalisé n'est fourni, le `StdoutLogger` est utilisé. Il délègue au package `logger` en interne.

En mode debug, tous les niveaux de journalisation (debug et supérieurs) sont émis. En mode release, seuls les avertissements et les erreurs sont produits.

Format des journaux :

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
