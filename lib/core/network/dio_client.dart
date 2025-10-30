import 'dart:convert';

import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/core/network/cache_interceptor.dart';
import 'package:budget_zise/data/services/device_info_service.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
part 'my_api_dio_interceptor.dart';

class MyDio {
  static Future<Dio> create(
    Logger logger,
    LocalStorageService localStorageService,
  ) async {
    final cacheOptions = await CacheInterceptorHelper.buildCacheOptions();

    final dio = Dio(
      BaseOptions(
        baseUrl: MyStrings.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        validateStatus: (status) => true,
      ),
    );

    dio.interceptors.add(_MyApiDioInterceptor(localStorageService));

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    // if (kIsWeb) {
    //   dio.interceptors.add(
    //     LogInterceptor(
    //       requestHeader: true,
    //       requestBody: true,
    //       responseHeader: true,
    //       responseBody: true,
    //       logPrint: (o) => logger.d(o.toString()),
    //     ),
    //   );
    // } else {
    //   dio.interceptors.add(
    //     LogInterceptor(
    //       requestHeader: true,
    //       requestBody: true,
    //       responseHeader: true,
    //       responseBody: true,
    //       logPrint: (o) => logger.d(o.toString()),
    //     ),
    //   );
    // }

    return dio;
  }
}

class DioClient {
  final Dio dio;

  DioClient(this.dio);
  Future<Response> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
