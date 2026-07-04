import 'package:equatable/equatable.dart';

class UserReportInfo extends Equatable {
  final String id;
  final String fullName;
  final String? phone;
  final String? email;

  const UserReportInfo({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
  });

  factory UserReportInfo.fromJson(Map<String, dynamic> json) => UserReportInfo(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
    phone: json['phone']?.toString(),
    email: json['email']?.toString(),
  );

  @override
  List<Object?> get props => [id, fullName, phone, email];
}
