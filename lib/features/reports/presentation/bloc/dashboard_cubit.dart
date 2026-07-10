import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../data/dashboard_repository.dart';
import '../../../../shared/models/dashboard_stats.dart';
import '../../../../shared/models/weekly_report_item.dart';
import '../../../../shared/models/map_report_point.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardScreenState> {
  final DashboardRepository _repo;
  DashboardCubit(this._repo) : super(const DashboardScreenState());

  Future<void> load() async {
    emit(state.copyWith(status: DashboardStatus.loading, errorMessage: null));
    try {
      final results = await Future.wait([
        _repo.getStats(),
        _repo.getWeekly(),
        _repo.getMapReports(),
      ]);
      
      emit(state.copyWith(
        status: DashboardStatus.loaded,
        stats: results[0] as DashboardStats,
        weeklyData: results[1] as List<WeeklyReportItem>,
        mapPoints: results[2] as List<MapReportPoint>,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.response?.data['message'] ?? e.message ?? 'Gagal memuat dashboard',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: 'Terjadi kesalahan sistem: $e',
      ));
    }
  }
}
