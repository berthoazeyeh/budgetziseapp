/// Exception de base pour les erreurs GraphQL
abstract class GraphQLException implements Exception {
  final String message;
  final String? code;

  GraphQLException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Erreur réseau (pas de connexion, timeout, etc.)
class NetworkException extends GraphQLException {
  NetworkException([String? message])
    : super(
        message ?? 'Erreur de connexion. Vérifiez votre connexion internet.',
      );
}

/// Erreur d'authentification (401, token invalide, etc.)
class AuthenticationException extends GraphQLException {
  AuthenticationException([String? message])
    : super(
        message ?? 'Session expirée. Veuillez vous reconnecter.',
        code: 'UNAUTHENTICATED',
      );
}

/// Erreur d'autorisation (403, pas de permissions)
class AuthorizationException extends GraphQLException {
  AuthorizationException([String? message])
    : super(
        message ?? 'Vous n\'avez pas les permissions nécessaires.',
        code: 'FORBIDDEN',
      );
}

/// Erreur de validation (champs invalides, etc.)
class ValidationException extends GraphQLException {
  final Map<String, List<String>>? fieldErrors;

  ValidationException(super.message, {this.fieldErrors})
    : super(code: 'VALIDATION_ERROR');
}

/// Erreur serveur (500, erreur interne)
class ServerException extends GraphQLException {
  ServerException([String? message])
    : super(
        message ?? 'Une erreur serveur est survenue. Réessayez plus tard.',
        code: 'INTERNAL_SERVER_ERROR',
      );
}

/// Erreur métier (logique applicative)
class BusinessException extends GraphQLException {
  BusinessException(super.message, {super.code});
}

/// Erreur inconnue
class UnknownException extends GraphQLException {
  UnknownException([String? message])
    : super(message ?? 'Une erreur inattendue est survenue.');
}
