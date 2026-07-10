import '../../../shared/models/user_model.dart';

class RegisterData {
  final UserModel user;

  RegisterData({required this.user});

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
    user: UserModel.fromJson(json['user']),
  );
}

class LoginData {
  final String accessToken;
  final UserModel user;

  LoginData({required this.accessToken, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    accessToken: json['accessToken'] ?? '',
    user: UserModel.fromJson(json['user']),
  );
}
