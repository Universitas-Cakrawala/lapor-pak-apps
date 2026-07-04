import 'package:equatable/equatable.dart';

class UserBrief extends Equatable {
  final String id;
  final String fullName;

  const UserBrief({required this.id, required this.fullName});

  factory UserBrief.fromJson(Map<String, dynamic> json) => UserBrief(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
  );

  @override
  List<Object?> get props => [id, fullName];
}
