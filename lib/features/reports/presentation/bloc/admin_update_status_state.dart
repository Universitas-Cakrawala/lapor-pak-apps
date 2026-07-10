import 'package:equatable/equatable.dart';
import '../../../../shared/models/report_model.dart';

enum AdminUpdateStatus { initial, loading, success, failure }

class AdminUpdateStatusState extends Equatable {
  final AdminUpdateStatus status;
  final String? errorMessage;
  final ReportModel? updatedReport;

  const AdminUpdateStatusState({
    this.status = AdminUpdateStatus.initial,
    this.errorMessage,
    this.updatedReport,
  });

  AdminUpdateStatusState copyWith({
    AdminUpdateStatus? status,
    String? errorMessage,
    ReportModel? updatedReport,
  }) {
    return AdminUpdateStatusState(
      status: status ?? this.status,
      errorMessage: errorMessage, // nullable clearing
      updatedReport: updatedReport ?? this.updatedReport,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, updatedReport];
}
