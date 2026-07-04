import 'package:equatable/equatable.dart';
import 'user_brief.dart';

enum ReportStatus { MENUNGGU, DIPROSES, SELESAI }

ReportStatus statusFromString(String s) => 
    ReportStatus.values.firstWhere((e) => e.name == s, orElse: () => ReportStatus.MENUNGGU);

class StatusHistoryModel extends Equatable {
  final String id;
  final ReportStatus status;
  final String? note;
  final String? proofPhotoUrl;
  final String? changedById;
  final DateTime timestamp;
  final UserBrief? changedBy;

  const StatusHistoryModel({
    required this.id,
    required this.status,
    this.note,
    this.proofPhotoUrl,
    this.changedById,
    required this.timestamp,
    this.changedBy,
  });

  factory StatusHistoryModel.fromJson(Map<String, dynamic> json) => StatusHistoryModel(
    id: json['id'] ?? '',
    status: statusFromString(json['status'] ?? ''),
    note: json['note']?.toString(),
    proofPhotoUrl: json['proofPhotoUrl']?.toString(),
    changedById: json['changedById']?.toString(),
    timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now() : DateTime.now(),
    changedBy: json['changedBy'] != null ? UserBrief.fromJson(json['changedBy']) : null,
  );

  @override
  List<Object?> get props => [id, status, note, proofPhotoUrl, changedById, timestamp, changedBy];
}
