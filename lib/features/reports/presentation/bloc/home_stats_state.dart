import 'package:equatable/equatable.dart';
import '../../../../shared/models/report_model.dart';
import '../../../../shared/models/report_stats_summary.dart';

class HomeStatsState extends Equatable {
  final ReportStatsSummary? stats;
  final List<ReportModel> recentReports;
  final bool isLoading;
  final String? error;

  const HomeStatsState({
    this.stats,
    this.recentReports = const [],
    this.isLoading = false,
    this.error,
  });

  HomeStatsState copyWith({
    ReportStatsSummary? stats,
    List<ReportModel>? recentReports,
    bool? isLoading,
    String? error,
  }) {
    return HomeStatsState(
      stats: stats ?? this.stats,
      recentReports: recentReports ?? this.recentReports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [stats, recentReports, isLoading, error];
}
