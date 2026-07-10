import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/report_model.dart';
import '../../../shared/models/report_stats_summary.dart';
import '../../../shared/models/paginated_reports.dart';
import '../../../shared/models/status_history_model.dart'; // for ReportStatus

class ReportsRepository {
  final Dio dio;
  ReportsRepository(this.dio);

  Future<ReportStatsSummary> getMyStats() async {
    final res = await dio.get('/reports/stats');
    return ReportStatsSummary.fromJson(extractData(res));
  }

  Future<PaginatedReports> list({
    int page = 1,
    int limit = 10,
    ReportStatus? status,
    String? search,
  }) async {
    final res = await dio.get('/reports', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status.name,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    // Parsing envelope langsung karena data & meta di level sama
    return PaginatedReports.fromEnvelope(res.data);
  }

  Future<ReportModel> getDetail(String id) async {
    final res = await dio.get('/reports/$id');
    return ReportModel.fromJson(extractData(res));
  }

  Future<ReportModel> create({
    required String roadName,
    required String description,
    required double latitude,
    required double longitude,
    required List<String> photoKeys,
    String? videoKey,
  }) async {
    final res = await dio.post('/reports', data: {
      'roadName': roadName,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrls': photoKeys,
      // ignore: use_null_aware_elements
      if (videoKey != null) 'videoUrl': videoKey,
    });
    return ReportModel.fromJson(extractData(res));
  }

  Future<ReportModel> update(String id, Map<String, dynamic> patch) async {
    final res = await dio.put('/reports/$id', data: patch);
    return ReportModel.fromJson(extractData(res));
  }

  Future<void> cancel(String id) async {
    await dio.delete('/reports/$id');
  }
}
