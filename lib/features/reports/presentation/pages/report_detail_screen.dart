import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/status_history_model.dart';
import '../../../../shared/models/report_model.dart';
import '../bloc/report_detail_cubit.dart';
import '../bloc/report_detail_state.dart';
import '../../../media/utils/media_helper.dart';
import '../widgets/status_timeline_widget.dart';
import 'package:video_player/video_player.dart';

class ReportDetailScreen extends StatefulWidget {
  final String id;
  const ReportDetailScreen({super.key, required this.id});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReportDetailCubit>().loadDetail(widget.id);
  }

  void _onCancel() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Batalkan Laporan?'),
        content: const Text('Laporan yang dibatalkan tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Tutup')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(c);
              context.read<ReportDetailCubit>().cancelReport(widget.id);
            },
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: BlocConsumer<ReportDetailCubit, ReportDetailState>(
        listener: (context, state) {
          if (state.status == ReportDetailStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Laporan dibatalkan'), backgroundColor: Colors.green),
            );
            context.pop();
          } else if (state.status == ReportDetailStatus.failure && state.report != null) {
            // Failure on delete action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Gagal membatalkan laporan'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ReportDetailStatus.loading || state.status == ReportDetailStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ReportDetailStatus.failure && state.report == null) {
            return Center(child: Text(state.errorMessage ?? 'Gagal memuat detail'));
          }
          final r = state.report;
          if (r == null) return const Center(child: Text('Laporan tidak ditemukan'));

          final isMenunggu = r.status == ReportStatus.MENUNGGU;

          return RefreshIndicator(
            onRefresh: () => context.read<ReportDetailCubit>().loadDetail(widget.id),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${r.id.split('-').first}',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                              _buildStatusBadge(r.status.name),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            r.roadName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r.description,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.location_on, color: AppColors.civicBlue),
                            title: const Text('Lokasi Koordinat'),
                            subtitle: Text('${r.latitude}, ${r.longitude}'),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(r.latitude, r.longitude),
                                initialZoom: 16.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.laporpak.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(r.latitude, r.longitude),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (r.photoUrls.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text('Foto Kejadian', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: r.photoUrls.length,
                                itemBuilder: (context, index) {
                                  final imageUrl = MediaHelper.displayUrl(r.photoUrls[index]);
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (c) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: EdgeInsets.zero,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              InteractiveViewer(child: Image.network(imageUrl)),
                                              Positioned(
                                                top: 40,
                                                right: 20,
                                                child: IconButton(
                                                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                                                  onPressed: () => Navigator.pop(c),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 120,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (r.videoUrl != null && r.videoUrl!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text('Video Kejadian', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (c) => FullScreenVideoDialog(videoUrl: MediaHelper.displayUrl(r.videoUrl!)),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: 120,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_circle_outline, color: Colors.white, size: 40),
                                      SizedBox(height: 8),
                                      Text('Putar Video', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Riwayat Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (r.history != null) StatusTimelineWidget(history: r.history!),
                  const SizedBox(height: 32),
                  if (state.isAdmin && r.status != ReportStatus.SELESAI) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.civicBlue),
                        onPressed: () async {
                          final updatedReport = await context.push('/admin/reports/${r.id}/status');
                          if (updatedReport != null && updatedReport is ReportModel) {
                            if (context.mounted) {
                              context.read<ReportDetailCubit>().updateReportData(updatedReport);
                            }
                          }
                        },
                        child: const Text('Update Status Laporan (Admin)', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (isMenunggu && !state.isAdmin) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                            onPressed: state.status == ReportDetailStatus.deleting ? null : _onCancel,
                            child: const Text('Batal', style: TextStyle(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (state.report != null) {
                                context.push('/reports/${state.report!.id}/edit', extra: state.report);
                              }
                            },
                            child: const Text('Edit Laporan'),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'MENUNGGU':
        color = AppColors.statusMenungguFg;
        break;
      case 'DIPROSES':
        color = AppColors.statusDiprosesFg;
        break;
      case 'SELESAI':
        color = AppColors.statusSelesaiFg;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class FullScreenVideoDialog extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoDialog({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoDialog> createState() => _FullScreenVideoDialogState();
}

class _FullScreenVideoDialogState extends State<FullScreenVideoDialog> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((e) {
        setState(() => _isError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isError)
            const Center(child: Text('Gagal memuat video', style: TextStyle(color: Colors.white)))
          else if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const CircularProgressIndicator(color: Colors.white),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (_controller.value.isInitialized)
            Positioned(
              bottom: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.white54,
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
                child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
