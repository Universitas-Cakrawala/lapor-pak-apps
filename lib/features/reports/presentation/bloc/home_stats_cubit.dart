import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reports_repository.dart';
import 'home_stats_state.dart';

class HomeStatsCubit extends Cubit<HomeStatsState> {
  final ReportsRepository _repo;

  HomeStatsCubit(this._repo) : super(const HomeStatsState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final stats = await _repo.getMyStats();
      final recent = await _repo.list(limit: 5);
      emit(state.copyWith(
        isLoading: false,
        stats: stats,
        recentReports: recent.data,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Terjadi kesalahan tidak terduga',
      ));
    }
  }
}
