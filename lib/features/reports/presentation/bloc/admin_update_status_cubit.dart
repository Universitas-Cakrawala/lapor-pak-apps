import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/status_repository.dart';
import '../../../media/data/media_repository.dart';
import '../../../media/utils/media_helper.dart';
import '../../../../shared/models/status_history_model.dart';
import 'admin_update_status_state.dart';

class AdminUpdateStatusCubit extends Cubit<AdminUpdateStatusState> {
  final StatusRepository _statusRepo;
  final MediaRepository _mediaRepo;

  AdminUpdateStatusCubit(this._statusRepo, this._mediaRepo)
      : super(const AdminUpdateStatusState());

  Future<void> submitStatus({
    required String reportId,
    required ReportStatus status,
    String? note,
    XFile? proofPhoto,
  }) async {
    emit(state.copyWith(status: AdminUpdateStatus.loading, errorMessage: null));

    try {
      String? proofPhotoKey;
      
      // Jika ada proofPhoto, kompres lalu upload untuk dapatkan key
      if (proofPhoto != null) {
        final compressedPhoto = await MediaHelper.compressImage(proofPhoto);
        final keys = await _mediaRepo.upload([compressedPhoto]);
        if (keys.isNotEmpty) {
          proofPhotoKey = keys.first;
        }
      }

      // Kirim status update ke repository
      final updatedReport = await _statusRepo.updateStatus(
        reportId,
        status: status,
        note: note,
        proofPhotoKey: proofPhotoKey,
      );

      emit(state.copyWith(
        status: AdminUpdateStatus.success,
        updatedReport: updatedReport,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: AdminUpdateStatus.failure,
        errorMessage: e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan jaringan',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdminUpdateStatus.failure,
        errorMessage: 'Gagal memperbarui status: $e',
      ));
    }
  }
}
