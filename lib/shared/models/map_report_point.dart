import 'package:equatable/equatable.dart';
import 'status_history_model.dart'; // Untuk ReportStatus

class MapReportPoint extends Equatable {
  final String id;
  final String roadName;
  final double latitude;
  final double longitude;
  final ReportStatus status;
  final DateTime createdAt;

  const MapReportPoint({
    required this.id,
    required this.roadName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory MapReportPoint.fromJson(Map<String, dynamic> json) => MapReportPoint(
    id: json['id'] ?? '',
    roadName: json['roadName'] ?? '',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    status: statusFromString(json['status'] ?? ''),
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
  );

  @override
  List<Object?> get props => [id, roadName, latitude, longitude, status, createdAt];
}
