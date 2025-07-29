import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';

Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on DioException catch (e) {
    throw NetworkException.fromDioException(e);
  } catch (e) {
    throw NetworkException(e.toString());
  }
}
