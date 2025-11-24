import 'dart:convert';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:gql_dio_link/gql_dio_link.dart';
// import 'package:gql_websocket_link/gql_websocket_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_query_compress/graphql_query_compress.dart';

import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry/sentry.dart' show SentryStatusCode;

class MyGraphQLClient extends GraphQLClient {
  final LocalStorageService localStorageService;

  MyGraphQLClient(this.localStorageService)
    : super(
        link: _buildLink(localStorageService),
        defaultPolicies: DefaultPolicies(
          query: Policies(
            error: ErrorPolicy.none,
            fetch: FetchPolicy.cacheAndNetwork,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
          mutate: Policies(
            error: ErrorPolicy.all,
            fetch: FetchPolicy.networkOnly,
          ),
          subscribe: Policies(
            error: ErrorPolicy.all,
            fetch: FetchPolicy.networkOnly,
          ),
        ),
        cache: GraphQLCache(store: HiveStore()),
      );

  static Link _buildLink(LocalStorageService localStorageService) {
    // Link HTTP pour queries et mutations
    final httpLink = Link.from([
      DedupeLink(),
      AuthLink(
        getToken: () async {
          final token1 = await localStorageService.getAccessToken();
          debugPrint(token1);
          const token =
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbklkIjoxMTcyLCJ1c2VybmFtZSI6ImVuZW90cmFjayIsInJvbGVzIjoiQ0xJRU5UIiwiaWF0IjoxNzI4NTU0NDcxfQ.g4WzrK9Lu2UODOyKBF6VAclJan-ySCXnDCOvN18Jqgg';

          if (_isTokenExpired(token1 ?? token)) {
            final newToken = await _refreshToken();
            return 'Bearer $newToken';
          }

          return 'Bearer ${token1 ?? token}';
        },
      ),

      ErrorLink(
        onGraphQLError: (request, forward, response) {
          for (final err in response.errors ?? []) {
            if (err.message.contains("UNAUTHENTICATED")) {
              // Ex: rafraîchir le token et relancer la requête
              _refreshToken().then((r) {
                final newReq = request.updateContextEntry<HttpLinkHeaders>(
                  (headers) =>
                      HttpLinkHeaders(headers: {"Authorization": "Bearer $r"}),
                );
                return forward(newReq);
              });
            }
          }
          return Stream.value(response);
        },
      ),
      DioLink(
        MyStrings.graphQLUrl,
        serializer: const RequestSerializerWithCompressor(),
        client: _buildDioClient(),
      ),
    ]);

    // Link WebSocket pour subscriptions
    final wsLink = WebSocketLink(
      MyStrings.graphQLWsUrl, // URL WebSocket
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: () async => {
          'headers': {
            'Authorization': 'Bearer ${LocalStorageService().getAccessToken()}',
          },
        },
        onConnectionLost: (code, reason) {
          return null;
        },
      ),
      subProtocol: GraphQLProtocol.graphqlTransportWs, // ou graphqlWs
    );

    // Split link : WebSocket pour subscriptions, HTTP pour le reste
    return Link.split((request) => request.isSubscription, wsLink, httpLink);
  }
}

// /// Vérifie si le token JWT est expiré
bool _isTokenExpired(String token) {
  try {
    // Décoder le JWT (partie payload en base64)
    final parts = token.split('.');
    if (parts.length != 3) {
      return true; // Token invalide
    }

    // Décoder le payload
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(decoded) as Map<String, dynamic>;

    // Vérifier l'expiration
    if (payloadMap.containsKey('exp')) {
      final exp = payloadMap['exp'] as int;
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // Ajouter une marge de 5 minutes avant expiration
      final isExpired = now.isAfter(
        expiryDate.subtract(const Duration(minutes: 5)),
      );

      if (isExpired) {
        debugPrint('Token expires at: $expiryDate (expired)');
      }

      return isExpired;
    }

    return false;
  } catch (e) {
    debugPrint('Error checking token expiration: $e');
    return true; // En cas d'erreur, considérer le token comme expiré
  }
}

Future<String> _refreshToken() async {
  LocalStorageService().setAccessToken('newToken');

  return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbklkIjoxMTcyLCJ1c2VybmFtZSI6ImVuZW90cmFjayIsInJvbGVzIjoiQ0xJRU5UIiwiaWF0IjoxNzI4NTU0NDcxfQ.g4WzrK9Lu2UODOyKBF6VAclJan-ySCXnDCOvN18Jqgg";
}

Dio _buildDioClient() {
  const timeout = Duration(seconds: 30);
  final dio = Dio(
    BaseOptions(
      followRedirects: false,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: true,
        logResponseHeaders: false,
        logger: print,
      ),
    );
  }

  dio.addSentry(
    failedRequestStatusCodes: [SentryStatusCode.range(400, 599)],
    captureFailedRequests: kDebugMode ? null : true,
  );

  return dio;
}







// /// Rafraîchit le token d'authentification
// Future<String> _refreshToken(LocalStorageService localStorageService) async {
//   try {
//     debugPrint('Refreshing token...');

//     // TODO: Appeler votre endpoint de refresh token
//     // Exemple:
//     // final refreshToken = await localStorageService.getRefreshToken();
//     // final response = await Dio().post(
//     //   '${MyStrings.apiUrl}/auth/refresh',
//     //   data: {'refreshToken': refreshToken},
//     // );
//     // final newToken = response.data['accessToken'];

//     // Pour le moment, token de test
//     const newToken = 'nouveau_token_rafraichi';

//     // Sauvegarder le nouveau token
//     await localStorageService.setAccessToken(newToken);

//     debugPrint('Token refreshed successfully');
//     return newToken;
//   } catch (e) {
//     debugPrint('Error refreshing token: $e');
//     rethrow;
//   }
// }