import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reports_repository.dart';
import '../../../users/data/users_repository.dart';
import '../../../../shared/models/report_model.dart';
import 'report_detail_state.dart';

class ReportDetailCubit extends Cubit<ReportDetailState> {
  final ReportsRepository _repo;
  final UsersRepository _usersRepo;

  ReportDetailCubit(this._repo, this._usersRepo) : super(const ReportDetailState());

  Future<void> loadDetail(String id) async {
    emit(state.copyWith(status: ReportDetailStatus.loading, errorMessage: null));
    try {
      final report = await _repo.getDetail(id);
      final profile = await _usersRepo.getMe();
      final isAdmin = profile?.role.name == 'ADMIN';
      emit(state.copyWith(status: ReportDetailStatus.loaded, report: report, isAdmin: isAdmin));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportDetailStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportDetailStatus.failure,
        errorMessage: 'Gagal memuat detail laporan',
      ));
    }
  }

  Future<void> cancelReport(String id) async {
    emit(state.copyWith(status: ReportDetailStatus.deleting, errorMessage: null));
    try {
      await _repo.cancel(id);
      emit(state.copyWith(status: ReportDetailStatus.deleteSuccess));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportDetailStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportDetailStatus.failure,
        errorMessage: 'Gagal membatalkan laporan',
      ));
    }
  }

  void updateReportData(ReportModel report) {
    emit(state.copyWith(report: report));
  }
}
