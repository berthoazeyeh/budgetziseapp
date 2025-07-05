part of 'dio_client.dart';

class _MyApiDioInterceptor extends Interceptor {
  final LocalStorageService _localStorageService;

  _MyApiDioInterceptor(this._localStorageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _localStorageService.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    debugPrint('📤 REQUEST: ${options.method} ${options.uri}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    debugPrint('Response StatusCode: $statusCode');
    debugPrint('Response Data: ${response.data}');

    if (statusCode >= 400) {
      final data = response.data;
      final errorMessage = data is Map && data['message'] != null
          ? data['message'].toString()
          : 'Erreur inconnue';

      // On prend le code HTTP car il est plus fiable
      final finalStatusCode = statusCode;

      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: NetworkException(
            errorMessage,
            statusCode: finalStatusCode,
            details: data.toString(),
          ),
        ),
        true,
      );
      return;
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Error StatusCode: $err');
    debugPrint('Error Data: ${err.response?.data}');

    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode != 0) {
      if (statusCode >= 500) {
        UiAlertHelper.showErrorToast(
          LocaleKeys.network_internal_server_error.tr(),
        );
      }

      if (statusCode == 401) {
        _localStorageService.deleteAccessToken();
      }
    } else {
      UiAlertHelper.showErrorToast(LocaleKeys.network_connection_error.tr());
    }
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: NetworkException.fromDioException(err),
    );
    super.onError(customError, handler);
  }
}
