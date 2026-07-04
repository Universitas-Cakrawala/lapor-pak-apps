import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../../../../shared/models/dashboard_stats.dart';
import '../../../../shared/models/weekly_report_item.dart';
import '../../../../shared/models/map_report_point.dart';
import '../../../../shared/models/status_history_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load();
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.MENUNGGU:
        return AppColors.amber;
      case ReportStatus.DIPROSES:
        return AppColors.civicBlue;
      case ReportStatus.SELESAI:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardCubit>().load(),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardScreenState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.initial || state.status == DashboardStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Gagal memuat dashboard'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().load(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final stats = state.stats!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(stats),
                const SizedBox(height: 24),
                const Text('Laporan Mingguan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildWeeklyChart(state.weeklyData),
                const SizedBox(height: 24),
                const Text('Peta Laporan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildMap(state.mapPoints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total Laporan', stats.totalLaporan.toString(), Icons.assignment, Colors.blueGrey),
        _buildStatCard('Menunggu', stats.menunggu.toString(), Icons.hourglass_empty, AppColors.amber),
        _buildStatCard('Diproses', stats.diproses.toString(), Icons.build, AppColors.civicBlue),
        _buildStatCard('Selesai', stats.selesai.toString(), Icons.check_circle, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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

  Widget _buildWeeklyChart(List<WeeklyReportItem> weeklyData) {
    if (weeklyData.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('Tidak ada data')));
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: weeklyData.asMap().entries.map<BarChartGroupData>((e) => BarChartGroupData(
              x: e.key,
              barRods: [BarChartRodData(
                toY: e.value.count.toDouble(), 
                color: AppColors.civicBlue,
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
              )],
            )).toList(),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < weeklyData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          weeklyData[value.toInt()].label.replaceAll(' - ', '\n'), 
                          style: const TextStyle(fontSize: 9),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(List<MapReportPoint> mapReports) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 300,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-6.2088, 106.8456), // Jakarta center
            initialZoom: 11,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.laporpak.app',
            ),
            MarkerLayer(
              markers: mapReports.map<Marker>((r) => Marker(
                point: LatLng(r.latitude, r.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => context.push('/reports/${r.id}'),
                  child: Icon(Icons.location_pin, color: _getStatusColor(r.status), size: 36),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
