import 'package:budget_zise/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AuthServices {
  final DioClient dio;

  AuthServices(this.dio);

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return dio.post(
      '/api/Auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> refreshToken({required String refreshToken}) async {
    return dio.post('/api/Auth/refresh', data: {'refresh_token': refreshToken});
  }

  Future<Response> logout() async {
    return dio.post('/api/Auth/logout');
  }

  Future<Response> me() async {
    return dio.get('/api/Auth/me');
  }

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return dio.post(
      '/api/Auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }
}
