import 'package:equatable/equatable.dart';
import '../../../../shared/models/report_model.dart';

enum ReportDetailStatus { initial, loading, loaded, failure, deleting, deleteSuccess }

class ReportDetailState extends Equatable {
  final ReportDetailStatus status;
  final ReportModel? report;
  final String? errorMessage;
  final bool isAdmin;

  const ReportDetailState({
    this.status = ReportDetailStatus.initial,
    this.report,
    this.errorMessage,
    this.isAdmin = false,
  });

  ReportDetailState copyWith({
    ReportDetailStatus? status,
    ReportModel? report,
    String? errorMessage,
    bool? isAdmin,
  }) {
    return ReportDetailState(
      status: status ?? this.status,
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  List<Object?> get props => [status, report, errorMessage, isAdmin];
}
