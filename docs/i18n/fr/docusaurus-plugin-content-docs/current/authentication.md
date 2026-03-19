---
sidebar_position: 2
title: Authentification
---

# Authentification

Misskey utilise une authentification par jeton. Un jeton secret (appelé `i` dans l'API Misskey) est injecté dans le corps de chaque requête POST authentifiée. Contrairement aux API basées sur OAuth, il n'y a pas d'en-tête Bearer — le jeton est transmis à l'intérieur du corps JSON.

## Fonctionnement de TokenProvider

`TokenProvider` est un typedef pour un rappel qui retourne un `FutureOr<String?>` :

```dart
typedef TokenProvider = FutureOr<String?> Function();
```

Le rappel est invoqué à chaque requête authentifiée. Cette conception vous permet de rafraîchir ou de charger les jetons en différé sans reconstruire le client.

### Jeton synchrone

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_token_here',
);
```

### Jeton asynchrone (par exemple, chargé depuis un stockage sécurisé)

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

### Modèle de renouvellement de jeton

Si votre jeton peut être renouvelé, retournez la valeur la plus récente depuis le fournisseur. Le client appelle toujours le rappel immédiatement avant l'envoi, il suffit donc de retourner une valeur à jour :

```dart
String? _cachedToken;

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => _cachedToken,
);

// Update the cached value whenever your token changes.
void onTokenRefreshed(String newToken) {
  _cachedToken = newToken;
}
```

## L'énumération AuthMode

Chaque point d'accès de l'API déclare ses exigences d'authentification via l'énumération `AuthMode` :

| Mode | Comportement |
|------|-------------|
| `AuthMode.required` | Le jeton est injecté ; lève une exception si aucun n'est fourni (par défaut) |
| `AuthMode.optional` | Le jeton est injecté s'il est disponible ; la requête s'exécute sans lui sinon |
| `AuthMode.none` | Le jeton n'est jamais injecté, quelle que soit la configuration du fournisseur |

Il s'agit d'un détail interne à la bibliothèque. En tant qu'utilisateur, vous n'avez qu'à fournir `tokenProvider`. La bibliothèque gère l'injection automatiquement.

Les points d'accès avec `AuthMode.optional` renvoient des réponses plus riches lorsqu'un jeton est présent. Par exemple, `notes/show` inclut les champs `myReaction` et `isFavorited` uniquement si un jeton est fourni.

## Obtention d'un jeton : le flux MiAuth

Misskey n'utilise pas OAuth 2.0. Le flux recommandé pour les applications tierces est **MiAuth**, un flux simplifié de redirection par navigateur.

```
1. Générer un UUID de session
2. Ouvrir l'URL MiAuth dans un navigateur
3. L'utilisateur accorde les permissions dans l'interface web Misskey
4. La redirection revient vers votre URL de rappel (ou vous interrogez l'API)
5. Échanger l'UUID de session contre un jeton
```

### Étape 1 : Construire l'URL d'autorisation

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
// Open authUrl in a browser or WebView
```

### Étape 2 : Échanger la session contre un jeton

Une fois que l'utilisateur a approuvé la demande, appelez le point d'accès de vérification. Il s'agit d'une simple requête HTTP GET qui ne passe pas par le chemin authentifié de la bibliothèque :

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/miauth/$session/check'),
);
final json = jsonDecode(response.body) as Map<String, dynamic>;
final token = json['token'] as String?;
```

Stockez le jeton en toute sécurité et transmettez-le à `tokenProvider`.

## Utilisation sans authentification

Ne passez pas de `tokenProvider` pour accéder aux points d'accès publics :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
);

// Works without a token
final info = await client.meta.fetch();
final notes = await client.notes.timelineLocal(limit: 10);
```

Appeler un point d'accès avec `AuthMode.required` sans fournisseur lève une `MisskeyUnauthorizedException`.
