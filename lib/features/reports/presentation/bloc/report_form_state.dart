import 'package:equatable/equatable.dart';

enum ReportFormStatus { initial, loading, success, failure }

class ReportFormState extends Equatable {
  final ReportFormStatus status;
  final String? errorMessage;
  final String? createdReportId; // Used for redirection after success

  const ReportFormState({
    this.status = ReportFormStatus.initial,
    this.errorMessage,
    this.createdReportId,
  });

  ReportFormState copyWith({
    ReportFormStatus? status,
    String? errorMessage,
    String? createdReportId,
  }) {
    return ReportFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdReportId: createdReportId ?? this.createdReportId,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, createdReportId];
}
