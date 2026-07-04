import 'package:equatable/equatable.dart';

enum UserRole { PELAPOR, ADMIN }

class UserModel extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? instansi;
  final String? fcmToken;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.instansi,
    this.fcmToken,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    username: json['username'] ?? '',
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    role: json['role'] == 'ADMIN' ? UserRole.ADMIN : UserRole.PELAPOR,
    instansi: json['instansi']?.toString(),
    fcmToken: json['fcmToken']?.toString(),
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
  );

  @override
  List<Object?> get props => [id, username, fullName, email, phone, role, instansi, fcmToken, createdAt];
}
