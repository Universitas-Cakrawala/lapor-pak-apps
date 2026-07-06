import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reports_repository.dart';
import '../../../media/data/media_repository.dart';
import '../../../media/utils/media_helper.dart';
import 'report_form_state.dart';

class ReportFormCubit extends Cubit<ReportFormState> {
  final ReportsRepository _repo;
  final MediaRepository _mediaRepo;

  ReportFormCubit(this._repo, this._mediaRepo) : super(const ReportFormState());

  Future<void> submitReport({
    required String roadName,
    required String description,
    required double latitude,
    required double longitude,
    required List<XFile> photos,
    XFile? video,
  }) async {
    emit(state.copyWith(status: ReportFormStatus.loading, errorMessage: null));
    try {
      // 1. Kompresi gambar (<= 2MB)
      final List<XFile> compressedPhotos = [];
      for (final photo in photos) {
        compressedPhotos.add(await MediaHelper.compressImage(photo));
      }

      // 2. Upload gambar ke /media/upload untuk mendapatkan keys
      final List<String> photoKeys = await _mediaRepo.upload(compressedPhotos);

      // 3. (Opsional) Upload video, asumsi untuk MVP kita kirim dummy key atau skip
      // Di PRD "Video tidak perlu dikompresi di skill ini". Tetapi uploadnya ke endpoint yang sama (multipart `files[]`).
      String? videoKey;
      if (video != null) {
        final videoKeys = await _mediaRepo.upload([video]);
        if (videoKeys.isNotEmpty) videoKey = videoKeys.first;
      }

      // 4. Submit laporan menggunakan keys
      final report = await _repo.create(
        roadName: roadName,
        description: description,
        latitude: latitude,
        longitude: longitude,
        photoKeys: photoKeys,
        videoKey: videoKey,
      );

      emit(state.copyWith(
        status: ReportFormStatus.success,
        createdReportId: report.id,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportFormStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportFormStatus.failure,
        errorMessage: 'Gagal mengirimkan laporan: $e',
      ));
    }
  }

  Future<void> updateReport({
    required String id,
    required String roadName,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    emit(state.copyWith(status: ReportFormStatus.loading, errorMessage: null));
    try {
      final report = await _repo.update(id, {
        'roadName': roadName,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      });

      emit(state.copyWith(
        status: ReportFormStatus.success,
        createdReportId: report.id,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ReportFormStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportFormStatus.failure,
        errorMessage: 'Gagal memperbarui laporan',
      ));
    }
  }
}
