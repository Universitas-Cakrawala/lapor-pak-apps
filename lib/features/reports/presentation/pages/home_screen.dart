import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../media/utils/media_helper.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../bloc/home_stats_cubit.dart';
import '../bloc/home_stats_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeStatsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<HomeStatsCubit, HomeStatsState>(
        builder: (context, state) {
          if (state.isLoading && state.stats == null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 24),
                  const ShimmerStatsGrid(),
                  const SizedBox(height: 32),
                  const ShimmerReportList(itemCount: 3),
                ],
              ),
            );
          }

          if (state.error != null && state.stats == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () => context.read<HomeStatsCubit>().load(),
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }

          final stats = state.stats;
          final recent = state.recentReports;

          return RefreshIndicator(
            onRefresh: () => context.read<HomeStatsCubit>().load(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(stats?.total ?? 0, stats?.menunggu ?? 0, stats?.diproses ?? 0, stats?.selesai ?? 0),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Laporan Terbaru',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => context.push('/reports'),
                        child: const Text('Lihat Semua'),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (recent.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Belum ada laporan', style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...recent.map((r) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => context.push('/reports/${r.id}'),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Photo thumbnail with Hero animation
                                  Hero(
                                    tag: 'report_photo_${r.id}',
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        image: r.photoUrls.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(MediaHelper.displayUrl(r.photoUrls.first)),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: r.photoUrls.isEmpty
                                          ? const Icon(Icons.broken_image, color: Colors.grey)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.roadName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          r.description,
                                          style: TextStyle(color: Colors.grey[600]),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd MMM yyyy').format(r.createdAt.toLocal()),
                                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                            ),
                                            _buildStatusBadge(r.status.name),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGreeting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.civicBlue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selamat Datang,', style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 4),
          Text('Warga', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(int total, int waiting, int process, int done) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total', total.toString(), Icons.assignment, Colors.blueGrey),
        _buildStatCard('Menunggu', waiting.toString(), Icons.hourglass_empty, Colors.orange),
        _buildStatCard('Diproses', process.toString(), Icons.build, Colors.blue),
        _buildStatCard('Selesai', done.toString(), Icons.check_circle, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color fgColor;
    switch (status) {
      case 'MENUNGGU':
        bgColor = AppColors.statusMenungguBg;
        fgColor = AppColors.statusMenungguFg;
        break;
      case 'DIPROSES':
        bgColor = AppColors.statusDiprosesBg;
        fgColor = AppColors.statusDiprosesFg;
        break;
      case 'SELESAI':
        bgColor = AppColors.statusSelesaiBg;
        fgColor = AppColors.statusSelesaiFg;
        break;
      default:
        bgColor = Colors.grey.shade300;
        fgColor = Colors.black87;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fgColor),
      ),
    );
  }
}
