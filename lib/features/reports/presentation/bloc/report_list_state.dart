import 'package:equatable/equatable.dart';
import '../../../../shared/models/report_model.dart';
import '../../../../shared/models/status_history_model.dart';

enum ReportListStatus { initial, loading, loaded, loadingMore, failure }

class ReportListState extends Equatable {
  final ReportListStatus status;
  final List<ReportModel> reports;
  final int currentPage;
  final int totalPages;
  final ReportStatus? filterStatus;
  final String? searchQuery;
  final String? errorMessage;

  const ReportListState({
    this.status = ReportListStatus.initial,
    this.reports = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.filterStatus,
    this.searchQuery,
    this.errorMessage,
  });

  bool get hasMore => currentPage < totalPages;

  ReportListState copyWith({
    ReportListStatus? status,
    List<ReportModel>? reports,
    int? currentPage,
    int? totalPages,
    ReportStatus? filterStatus,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ReportListState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      // Status & Search nulling requires a bit of logic if we want to clear them.
      // But for simplicity, we pass null to not change, or use a separate method to clear.
      filterStatus: filterStatus, // In Dart, usually we can pass a Wrapper or check for specific clear flag. We'll just pass directly.
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reports,
        currentPage,
        totalPages,
        filterStatus,
        searchQuery,
        errorMessage,
      ];
}
