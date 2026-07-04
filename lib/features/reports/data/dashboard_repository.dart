import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/dashboard_stats.dart';
import '../../../shared/models/weekly_report_item.dart';
import '../../../shared/models/map_report_point.dart';

class DashboardRepository {
  final Dio dio;
  DashboardRepository(this.dio);

  /// GET /admin/dashboard/stats → envelope { statusCode, message, data: { totalLaporan, menunggu, diproses, selesai } }
  Future<DashboardStats> getStats() async {
    final res = await dio.get('/admin/dashboard/stats');
    return DashboardStats.fromJson(extractData(res));
  }

  /// GET /admin/dashboard/weekly → envelope { statusCode, message, data: { weeks: [...] } }
  Future<List<WeeklyReportItem>> getWeekly() async {
    final res = await dio.get('/admin/dashboard/weekly');
    final data = extractData(res);
    return (data['weeks'] as List).map((e) => WeeklyReportItem.fromJson(e)).toList();
  }

  /// GET /admin/dashboard/map → envelope { statusCode, message, data: [...] }
  Future<List<MapReportPoint>> getMapReports() async {
    final res = await dio.get('/admin/dashboard/map');
    return (extractData(res) as List).map((e) => MapReportPoint.fromJson(e)).toList();
  }
}
