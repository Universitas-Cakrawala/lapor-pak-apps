import 'package:equatable/equatable.dart';
import '../../../../shared/models/dashboard_stats.dart';
import '../../../../shared/models/weekly_report_item.dart';
import '../../../../shared/models/map_report_point.dart';

enum DashboardStatus { initial, loading, loaded, failure }

class DashboardScreenState extends Equatable {
  final DashboardStatus status;
  final DashboardStats? stats;
  final List<WeeklyReportItem> weeklyData;
  final List<MapReportPoint> mapPoints;
  final String? errorMessage;

  const DashboardScreenState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.weeklyData = const [],
    this.mapPoints = const [],
    this.errorMessage,
  });

  DashboardScreenState copyWith({
    DashboardStatus? status,
    DashboardStats? stats,
    List<WeeklyReportItem>? weeklyData,
    List<MapReportPoint>? mapPoints,
    String? errorMessage,
  }) {
    return DashboardScreenState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      weeklyData: weeklyData ?? this.weeklyData,
      mapPoints: mapPoints ?? this.mapPoints,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, weeklyData, mapPoints, errorMessage];
}
