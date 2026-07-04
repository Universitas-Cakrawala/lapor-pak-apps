import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reports_repository.dart';
import '../../../../shared/models/status_history_model.dart';
import 'report_list_state.dart';

class ReportListCubit extends Cubit<ReportListState> {
  final ReportsRepository _repo;

  ReportListCubit(this._repo) : super(const ReportListState());

  Future<void> loadReports({ReportStatus? status, String? search}) async {
    emit(state.copyWith(
      status: ReportListStatus.loading,
      filterStatus: status,
      searchQuery: search,
    ));
    try {
      final result = await _repo.list(page: 1, status: status, search: search);
      emit(state.copyWith(
        status: ReportListStatus.loaded,
        reports: result.data,
        currentPage: result.page,
        totalPages: result.totalPages,
        // Ensure filterStatus and searchQuery persist if passed
        filterStatus: status,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportListStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportListStatus.failure,
        errorMessage: 'Terjadi kesalahan saat memuat daftar laporan',
      ));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == ReportListStatus.loadingMore) return;
    
    emit(state.copyWith(status: ReportListStatus.loadingMore));
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repo.list(
        page: nextPage,
        status: state.filterStatus,
        search: state.searchQuery,
      );
      emit(state.copyWith(
        status: ReportListStatus.loaded,
        reports: [...state.reports, ...result.data],
        currentPage: result.page,
        totalPages: result.totalPages,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportListStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportListStatus.failure,
        errorMessage: 'Terjadi kesalahan saat memuat lebih banyak laporan',
      ));
    }
  }
}
