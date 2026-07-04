import 'package:equatable/equatable.dart';
import 'status_history_model.dart';
import 'user_report_info.dart';

class ReportModel extends Equatable {
  final String id;
  final String roadName;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> photoUrls;
  final String? videoUrl;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserReportInfo? user;
  final List<StatusHistoryModel>? history;

  const ReportModel({
    required this.id,
    required this.roadName,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.photoUrls,
    this.videoUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.history,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['id'] ?? '',
    roadName: json['roadName'] ?? '',
    description: json['description'] ?? '',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    photoUrls: List<String>.from(json['photoUrls'] ?? []),
    videoUrl: json['videoUrl']?.toString(),
    status: statusFromString(json['status'] ?? ''),
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
    user: json['user'] != null ? UserReportInfo.fromJson(json['user']) : null,
    history: json['history'] != null
        ? (json['history'] as List).map((h) => StatusHistoryModel.fromJson(h)).toList()
        : null,
  );

  @override
  List<Object?> get props => [
        id, roadName, description, latitude, longitude,
        photoUrls, videoUrl, status, createdAt, updatedAt,
        user, history,
      ];
}
