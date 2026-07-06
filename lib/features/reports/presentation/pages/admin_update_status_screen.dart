import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/status_history_model.dart';
import '../bloc/admin_update_status_cubit.dart';
import '../bloc/admin_update_status_state.dart';
import '../widgets/media_picker_widget.dart';

class AdminUpdateStatusScreen extends StatefulWidget {
  final String id;
  const AdminUpdateStatusScreen({super.key, required this.id});

  @override
  State<AdminUpdateStatusScreen> createState() => _AdminUpdateStatusScreenState();
}

class _AdminUpdateStatusScreenState extends State<AdminUpdateStatusScreen> {
  ReportStatus _selectedStatus = ReportStatus.DIPROSES;
  final _noteCtrl = TextEditingController();
  
  // Reuse MediaPickerWidget tapi kita cuma butuh 1 foto
  // Karena MediaPickerWidget di-design multi-foto (List<File>),
  // kita ambil yang index 0 sebagai proofPhoto.
  XFile? _proofPhoto;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedStatus == ReportStatus.SELESAI && _proofPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status SELESAI mewajibkan upload foto bukti!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AdminUpdateStatusCubit>().submitStatus(
      reportId: widget.id,
      status: _selectedStatus,
      note: _noteCtrl.text,
      proofPhoto: _proofPhoto,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Status (Admin)'),
      ),
      body: BlocConsumer<AdminUpdateStatusCubit, AdminUpdateStatusState>(
        listener: (context, state) {
          if (state.status == AdminUpdateStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Status berhasil diupdate!'), backgroundColor: Colors.green),
            );
            // Kembalikan updated report ke layar detail
            context.pop(state.updatedReport);
          } else if (state.status == AdminUpdateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Gagal update status'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isSelesai = _selectedStatus == ReportStatus.SELESAI;
          // Validasi form aktif / disable submit
          final bool canSubmit = !isSelesai || (isSelesai && _proofPhoto != null);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih Status Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ReportStatus>(
                      value: _selectedStatus,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: ReportStatus.DIPROSES,
                          child: Text('DIPROSES'),
                        ),
                        DropdownMenuItem(
                          value: ReportStatus.SELESAI,
                          child: Text('SELESAI'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStatus = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Catatan Tambahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteCtrl,
                  maxLength: 500,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan catatan progres atau penyelesaian di lapangan...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                // Bukti Foto jika selesai
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSelesai
                      ? Column(
                          key: const ValueKey('foto_selesai'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Foto Bukti Penyelesaian (Wajib)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            // Pakai MediaPickerWidget, tapi cuma perbolehkan foto.
                            // Pengguna bisa pilih 1 foto.
                            MediaPickerWidget(
                              onMediaChanged: (photos, video) {
                                setState(() {
                                  _proofPhoto = photos.isNotEmpty ? photos.first : null;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '*Pilih maksimal 1 foto. Video akan diabaikan.',
                              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                            )
                          ],
                        )
                      : const SizedBox.shrink(key: ValueKey('foto_kosong')),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (state.status == AdminUpdateStatus.loading || !canSubmit)
                        ? null
                        : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.civicBlue,
                    ),
                    child: state.status == AdminUpdateStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Update Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
