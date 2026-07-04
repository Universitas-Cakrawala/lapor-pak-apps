import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import 'auth_models.dart';

class AuthRepository {
  final Dio dio;
  AuthRepository(this.dio);

  Future<RegisterData> register({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String rePassword,
  }) async {
    final res = await dio.post('/auth/register', data: {
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'rePassword': rePassword,
    });
    return RegisterData.fromJson(extractData(res));
  }

  Future<LoginData> login({
    required String username,
    required String password,
  }) async {
    final res = await dio.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    return LoginData.fromJson(extractData(res));
  }
}
