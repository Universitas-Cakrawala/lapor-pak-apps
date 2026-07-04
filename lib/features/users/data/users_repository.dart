import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/user_model.dart';

class UsersRepository {
  final Dio dio;
  UsersRepository(this.dio);

  Future<UserModel?> getMe() async {
    try {
      final res = await dio.get('/users/me');
      return UserModel.fromJson(extractData(res));
    } catch (e) {
      return null;
    }
  }
}
