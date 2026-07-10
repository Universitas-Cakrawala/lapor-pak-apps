import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/auth_repository.dart';
import '../../../users/data/users_repository.dart';
import 'auth_state.dart';
import '../../../../core/network/fcm_service.dart';
import '../../../../core/router/app_router.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepo;
  final UsersRepository _usersRepo;

  AuthCubit(this._authRepo, this._usersRepo) : super(const AuthState());

  Future<void> register({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String rePassword,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepo.register(
        username: username,
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        rePassword: rePassword,
      );
      emit(state.copyWith(status: AuthStatus.success));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Terjadi kesalahan tidak terduga',
      ));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final loginData = await _authRepo.login(
        username: username,
        password: password,
      );
      
      const storage = FlutterSecureStorage();
      await storage.write(key: 'jwt_token', value: loginData.accessToken);
      
      // Setup FCM setelah login sukses
      try {
        await FcmService.setupPushNotifications(_usersRepo, appRouter);
      } catch (_) {}

      emit(state.copyWith(
        status: AuthStatus.success,
        user: loginData.user,
        accessToken: loginData.accessToken,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message, // Menampilkan error spesifik (atau 401 Unauthorized via interceptor msg)
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Terjadi kesalahan tidak terduga',
      ));
    }
  }

  Future<void> checkSession() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');
    
    if (token == null) {
      emit(state.copyWith(status: AuthStatus.failure));
      return;
    }

    try {
      final user = await _usersRepo.getMe();
      if (user == null) {
        await storage.delete(key: 'jwt_token');
        emit(state.copyWith(status: AuthStatus.failure));
      } else {
        // Setup FCM saat session direstore (app restart)
        try {
          await FcmService.setupPushNotifications(_usersRepo, appRouter);
        } catch (_) {}

        emit(state.copyWith(
          status: AuthStatus.success,
          user: user,
          accessToken: token,
        ));
      }
    } catch (_) {
      await storage.delete(key: 'jwt_token');
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> logout() async {
    try {
      await _usersRepo.updateFcmToken('');
    } catch (_) {}
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    emit(const AuthState(status: AuthStatus.initial));
  }
}
