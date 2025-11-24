// lib/core/exceptions/network_exception.dart

import 'package:budget_zise/budget_zise.dart' show StringTranslateExtension;
import 'package:budget_zise/gen/locale_keys.g.dart';
import 'package:dio/dio.dart';

/// Classe personnalisée pour gérer les erreurs réseau plus proprement.
class DioNetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  DioNetworkException(this.message, {this.statusCode, this.details});

  /// Fabrique une DioNetworkException à partir d'une exception Dio
  factory DioNetworkException.fromDioException(DioException dioError) {
    String message = LocaleKeys.network_unknown.tr();
    final int? code = dioError.response?.statusCode;
    final dynamic details = dioError.response?.data;

    if (dioError.type == DioExceptionType.connectionTimeout ||
        dioError.type == DioExceptionType.sendTimeout ||
        dioError.type == DioExceptionType.receiveTimeout) {
      message =
          details['message'] ??
          dioError.message ??
          LocaleKeys.network_timeout.tr();
    } else if (dioError.type == DioExceptionType.badResponse) {
      message = _getServerErrorMessage(code, details);
    } else if (dioError.type == DioExceptionType.cancel) {
      message = LocaleKeys.network_cancelled.tr();
    } else if (dioError.type == DioExceptionType.connectionError) {
      message =
          details['message'] ??
          dioError.message ??
          LocaleKeys.network_connection_error.tr();
    } else {
      message =
          details['message'] ??
          dioError.message ??
          LocaleKeys.network_unknown.tr();
    }

    return DioNetworkException(message, statusCode: code, details: details);
  }

  static String _getServerErrorMessage(int? statusCode, dynamic details) {
    switch (statusCode) {
      case 400:
        return details['message'] ?? LocaleKeys.network_bad_request.tr();
      case 401:
        return details['message'] ?? LocaleKeys.network_unauthorized.tr();
      case 403:
        return details['message'] ?? LocaleKeys.network_forbidden.tr();
      case 404:
        return details['message'] ?? LocaleKeys.network_not_found.tr();
      case 500:
        return LocaleKeys.network_internal_server_error.tr();
      case 502:
        return LocaleKeys.network_bad_gateway.tr();
      case 503:
        return LocaleKeys.network_service_unavailable.tr();
      case 504:
        return LocaleKeys.network_gateway_timeout.tr();
      default:
        return LocaleKeys.network_internal_server_error.tr();
    }
  }

  @override
  String toString() =>
      'DioNetworkException(statusCode: $statusCode, message: $message, details: $details)';
}
