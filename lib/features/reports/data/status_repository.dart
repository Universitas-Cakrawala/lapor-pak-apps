import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/report_model.dart';
import '../../../shared/models/status_history_model.dart';

class StatusRepository {
  final Dio dio;
  
  StatusRepository(this.dio);

  /// GET /reports/{id}/history → envelope { statusCode, message, data: [...history] }
  Future<List<StatusHistoryModel>> getHistory(String reportId) async {
    final res = await dio.get('/reports/$reportId/history');
    final data = extractData(res);
    return (data as List).map((e) => StatusHistoryModel.fromJson(e)).toList();
  }

  /// PATCH /admin/reports/{id}/status → envelope { statusCode, message, data: { ...report with history } }
  Future<ReportModel> updateStatus(
    String reportId, {
    required ReportStatus status,
    String? note,
    String? proofPhotoKey,
  }) async {
    final res = await dio.patch('/admin/reports/$reportId/status', data: {
      'status': status.name,
      // ignore: use_null_aware_elements
      if (note != null) 'note': note,
      // ignore: use_null_aware_elements
      if (proofPhotoKey != null) 'proofPhotoUrl': proofPhotoKey,
    });
    return ReportModel.fromJson(extractData(res));
  }
}
