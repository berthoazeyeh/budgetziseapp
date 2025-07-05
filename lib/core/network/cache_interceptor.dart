import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class CacheInterceptorHelper {
  static Future<CacheOptions> buildCacheOptions() async {
    final dir = await getApplicationDocumentsDirectory();

    return CacheOptions(
      store: HiveCacheStore(dir.path),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );
  }
}
