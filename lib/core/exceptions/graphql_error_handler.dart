import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as gql;
import 'graphql_exceptions.dart';

class GraphQLErrorHandler {
  /// Parse une OperationException en exception personnalisée
  static GraphQLException handleException(gql.OperationException exception) {
    // 1. Erreurs GraphQL (erreurs métier retournées par l'API)
    if (exception.graphqlErrors.isNotEmpty) {
      return _handleGraphQLErrors(exception.graphqlErrors);
    }

    // 2. Erreurs de link (réseau, timeout, etc.)
    if (exception.linkException != null) {
      return _handleLinkException(exception.linkException!);
    }

    // 3. Erreur inconnue
    return UnknownException(exception.toString());
  }

  /// Gère les erreurs GraphQL (du serveur)
  static GraphQLException _handleGraphQLErrors(List<gql.GraphQLError> errors) {
    final firstError = errors.first;
    final code = firstError.extensions?['code'] as String?;
    final message = firstError.message;

    // 🔧 AJOUT : Gérer les erreurs spécifiques par message
    // (avant le switch pour prioriser les messages spécifiques)
    if (message.contains('INVALID_USERNAME_OR_PASSWORD')) {
      return ValidationException(
        'Nom d\'utilisateur ou mot de passe incorrect',
      );
    }

    if (message.contains('USER_NOT_FOUND')) {
      return ValidationException('Utilisateur non trouvé');
    }

    if (message.contains('ACCOUNT_LOCKED')) {
      return AuthenticationException(
        'Compte verrouillé. Contactez le support.',
      );
    }

    if (message.contains('EMAIL_NOT_VERIFIED')) {
      return BusinessException(
        'Veuillez vérifier votre email avant de vous connecter',
        code: 'EMAIL_NOT_VERIFIED',
      );
    }

    switch (code) {
      case 'UNAUTHENTICATED':
      case 'UNAUTHORIZED':
        return AuthenticationException(message);

      case 'FORBIDDEN':
        return AuthorizationException(message);

      case 'BAD_USER_INPUT':
      case 'VALIDATION_ERROR':
        // Parser les erreurs de validation si disponibles
        final fieldErrors =
            firstError.extensions?['validationErrors'] as Map<String, dynamic>?;
        return ValidationException(
          message,
          fieldErrors: fieldErrors?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ),
        );

      case 'INTERNAL_SERVER_ERROR':
        // 🔧 AJOUT : Distinguer les erreurs métier des vraies erreurs serveur
        if (message.contains('INVALID') ||
            message.contains('NOT_FOUND') ||
            message.contains('ALREADY_EXISTS') ||
            message.contains('EXPIRED')) {
          return BusinessException(message, code: code);
        }
        return ServerException(message);

      default:
        // Erreur métier personnalisée
        return BusinessException(message, code: code);
    }
  }

  /// Gère les erreurs de connexion/réseau
  static GraphQLException _handleLinkException(gql.LinkException exception) {
    if (exception is gql.ServerException) {
      final statusCode = exception.statusCode;

      if (statusCode == 401) {
        return AuthenticationException();
      }

      if (statusCode == 403) {
        return AuthorizationException();
      }

      if (statusCode != null && statusCode >= 500) {
        return ServerException();
      }

      return ServerException(exception.originalException?.toString());
    }

    if (exception is gql.NetworkException) {
      return NetworkException();
    }

    return UnknownException(exception.toString());
  }

  /// Obtient un message utilisateur friendly
  static String getUserMessage(GraphQLException exception) {
    if (exception is NetworkException) {
      return 'Pas de connexion internet. Vérifiez votre réseau.';
    }

    if (exception is AuthenticationException) {
      return 'Votre session a expiré. Reconnectez-vous.';
    }

    if (exception is AuthorizationException) {
      return 'Accès refusé. Vous n\'avez pas les permissions nécessaires.';
    }

    if (exception is ValidationException) {
      return exception.message;
    }

    if (exception is ServerException) {
      return 'Le serveur rencontre des difficultés. Réessayez plus tard.';
    }

    // 🔧 AJOUT : Gérer BusinessException
    if (exception is BusinessException) {
      return exception.message;
    }

    return exception.message;
  }

  // 🆕 BONUS : Helper pour vérifier si c'est une erreur d'authentification
  static bool isAuthError(GraphQLException exception) {
    return exception is AuthenticationException ||
        (exception is BusinessException &&
            (exception.code == 'UNAUTHENTICATED' ||
                exception.code == 'UNAUTHORIZED'));
  }

  // 🆕 BONUS : Helper pour savoir si on doit déconnecter l'utilisateur
  static bool shouldLogout(GraphQLException exception) {
    return exception is AuthenticationException ||
        (exception is BusinessException && exception.code == 'SESSION_EXPIRED');
  }
}

class AppErrorHandler {
  static void handle(dynamic error, StackTrace? stackTrace) {
    debugPrint("❌ Error caught: $error");

    if (error is ValidationException ||
        error is AuthenticationException ||
        error is NetworkException ||
        error is BusinessException ||
        error is GraphQLException) {
      UiAlertHelper.showErrorToast(GraphQLErrorHandler.getUserMessage(error));
      return;
    }

    // Default fallback
    UiAlertHelper.showErrorToast(
      'Une erreur inattendue est survenue. Veuillez réessayer.',
    );

    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
