import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/status_history_model.dart';
import '../bloc/report_list_cubit.dart';
import '../bloc/report_list_state.dart';
import '../../../media/utils/media_helper.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ReportListCubit>().loadReports();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<ReportListCubit>().loadMore();
    }
  }

  void _onSearch(String val) {
    context.read<ReportListCubit>().loadReports(search: val);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Saya'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari laporan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    _onSearch('');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onSubmitted: _onSearch,
            ),
          ),
          BlocBuilder<ReportListCubit, ReportListState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip(context, state, null, 'Semua'),
                    _buildFilterChip(context, state, ReportStatus.MENUNGGU, 'Menunggu'),
                    _buildFilterChip(context, state, ReportStatus.DIPROSES, 'Diproses'),
                    _buildFilterChip(context, state, ReportStatus.SELESAI, 'Selesai'),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<ReportListCubit, ReportListState>(
              builder: (context, state) {
                if (state.status == ReportListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.status == ReportListStatus.failure && state.reports.isEmpty) {
                  return Center(
                    child: Text(state.errorMessage ?? 'Gagal memuat', style: const TextStyle(color: Colors.red)),
                  );
                }

                if (state.reports.isEmpty) {
                  return const Center(child: Text('Tidak ada laporan'));
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<ReportListCubit>().loadReports(
                    status: state.filterStatus,
                    search: state.searchQuery,
                  ),
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.reports.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= state.reports.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final r = state.reports[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/reports/${r.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('dd MMM yyyy, HH:mm').format(r.createdAt.toLocal()),
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    _buildStatusBadge(r.status.name),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  r.roadName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                                if (r.photoUrls.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(MediaHelper.displayUrl(r.photoUrls.first)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, ReportListState state, ReportStatus? status, String label) {
    final isSelected = state.filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          if (selected) {
            context.read<ReportListCubit>().loadReports(status: status, search: _searchCtrl.text);
          } else {
            // Kalau di-unselect, kembalikan ke Semua (null)
            context.read<ReportListCubit>().loadReports(status: null, search: _searchCtrl.text);
          }
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
