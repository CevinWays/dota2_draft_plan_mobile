import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  DioClient._();

  static Dio createDio(SharedPreferences sharedPreferences) {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'http://192.168.0.119:8000/api',
        ),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString('CACHED_TOKEN');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );

    return dio;
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
