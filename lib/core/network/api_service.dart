// import 'package:budget_zise/budget_zise.dart';
// import 'package:budget_zise/core/exceptions/network_exception.dart';
// import 'package:budget_zise/gen/locale_keys.g.dart';

// class ApiService {
//   late final Dio _dio;
//   static const String baseUrl = 'https://api.example.com';

//   ApiService({String? authToken}) {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         sendTimeout: const Duration(seconds: 30),
//       ),
//     );
//     _dio.interceptors.add(_MyApiDioInterceptor(localStorageService));
//   }

//   // void _setupInterceptors(String? authToken) {
//   //   // Interceptor de connectivité

//   //   // Interceptor personnalisé
//   //   _dio.interceptors.add(ApiInterceptor(authToken: authToken));

//   //   // Logger (uniquement en mode debug)
//   //   if (kDebugMode) {
//   //     _dio.interceptors.add(
//   //       PrettyDioLogger(
//   //         requestHeader: true,
//   //         requestBody: true,
//   //         responseBody: true,
//   //         responseHeader: false,
//   //         compact: false,
//   //       ),
//   //     );
//   //   }
//   // }

//   // Méthodes API
//   Future<Response> get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     try {
//       return await _dio.get(path, queryParameters: queryParameters);
//     } on DioException catch (e) {
//       throw _extractApiException(e);
//     }
//   }

//   Future<Response> post(String path, {dynamic data}) async {
//     try {
//       return await _dio.post(path, data: data);
//     } on DioException catch (e) {
//       throw _extractApiException(e);
//     }
//   }

//   Future<Response> put(String path, {dynamic data}) async {
//     try {
//       return await _dio.put(path, data: data);
//     } on DioException catch (e) {
//       throw _extractApiException(e);
//     }
//   }

//   Future<Response> delete(String path) async {
//     try {
//       return await _dio.delete(path);
//     } on DioException catch (e) {
//       throw _extractApiException(e);
//     }
//   }

//   NetworkException _extractApiException(DioException e) {
//     if (e.error is NetworkException) {
//       return e.error as NetworkException;
//     }
//     return NetworkException(LocaleKeys.network_unknown.tr());
//   }
// }
