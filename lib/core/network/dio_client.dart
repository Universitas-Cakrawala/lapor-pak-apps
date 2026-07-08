import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../router/app_router.dart';

class DioClient {
  final _storage = const FlutterSecureStorage();
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      headers: {
        'ngrok-skip-browser-warning': 'true',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'jwt_token');
          appRouter.go('/login');
          return handler.next(e.copyWith(message: 'Sesi berakhir, silakan login kembali.'));
        }

        final data = e.response?.data;
        String msg = 'Terjadi kesalahan. Coba lagi.';

        if (data is Map) {
          if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
            msg = (data['errors'] as List).join(', ');
          } else if (data['message'] != null) {
            msg = data['message'] is List
                ? (data['message'] as List).join(', ')
                : data['message'].toString();
          }
        }
        handler.next(e.copyWith(message: msg));
      },
    ));
  }
}

/// Helper untuk ekstraksi aman dari Envelope { statusCode, message, data }
T extractData<T>(Response response) => response.data['data'] as T;
