import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/status_history_model.dart';
import '../../../media/utils/media_helper.dart';

class StatusTimelineWidget extends StatelessWidget {
  final List<StatusHistoryModel> history;

  const StatusTimelineWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Text('Belum ada riwayat status.', style: TextStyle(color: Colors.grey));
    }

    // Urutkan berdasarkan timestamp ascending (terlama di atas) 
    // atau descending? Biasa timeline terlama di atas, yang terbaru di bawah,
    // atau terbaru di atas. SKILL.md bilang:
    // "Render List<StatusHistoryModel> terurut dari timestamp (ascending: diajukan -> selesai)"
    final sortedHistory = List<StatusHistoryModel>.from(history)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(sortedHistory.length, (index) {
        final item = sortedHistory[index];
        final isLast = index == sortedHistory.length - 1;
        // Elemen terakhir (terbaru) mendapatkan efek highlight
        return _buildTimelineItem(context, item, isLast, isLastItem: isLast);
      }),
    );
  }

  Widget _buildTimelineItem(BuildContext context, StatusHistoryModel item, bool isHighlight, {required bool isLastItem}) {
    Color getStatusColor(ReportStatus status) {
      switch (status) {
        case ReportStatus.MENUNGGU:
          return AppColors.amber;
        case ReportStatus.DIPROSES:
          return AppColors.civicBlue;
        case ReportStatus.SELESAI:
          return Colors.green;
      }
    }

    final color = getStatusColor(item.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indikator Garis dan Titik
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: isHighlight ? 20 : 16,
                height: isHighlight ? 20 : 16,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isHighlight ? 1.0 : 0.5),
                  shape: BoxShape.circle,
                  border: isHighlight ? Border.all(color: color.withValues(alpha: 0.3), width: 4) : null,
                ),
              ),
              if (!isLastItem)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.status.name,
                        style: TextStyle(
                          fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                          color: isHighlight ? color : Colors.grey[700],
                          fontSize: isHighlight ? 16 : 14,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(item.timestamp.toLocal()),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  if (item.changedBy != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Oleh: ${item.changedBy!.fullName}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                  if (item.note != null && item.note!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        item.note!,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ),
                  ],
                  if (item.proofPhotoUrl != null && item.proofPhotoUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Bukti Pekerjaan:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(MediaHelper.displayUrl(item.proofPhotoUrl!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
