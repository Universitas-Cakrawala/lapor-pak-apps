import 'package:equatable/equatable.dart';
import 'report_model.dart';

class PaginatedReports extends Equatable {
  final List<ReportModel> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedReports({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  /// Parse dari envelope response `GET /reports`.
  /// Response shape: { statusCode, message, data: [...], meta: { total, page, limit, totalPages } }
  /// Panggil dengan `PaginatedReports.fromEnvelope(res.data)`.
  factory PaginatedReports.fromEnvelope(Map<String, dynamic> envelope) {
    return PaginatedReports(
      data: (envelope['data'] as List?)?.map((e) => ReportModel.fromJson(e)).toList() ?? [],
      page: envelope['meta']?['page'] ?? 1,
      limit: envelope['meta']?['limit'] ?? 10,
      total: envelope['meta']?['total'] ?? 0,
      totalPages: envelope['meta']?['totalPages'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [data, page, limit, total, totalPages];
}
