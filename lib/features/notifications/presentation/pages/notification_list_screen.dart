import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tandai semua sudah dibaca',
            onPressed: () {
              context.read<NotificationCubit>().markAllAsRead();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Gagal memuat notifikasi',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return const Center(child: Text('Belum ada notifikasi'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationCubit>().fetchNotifications(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return ListTile(
                  tileColor: notif.isRead
                      ? null
                      : AppColors.civicBlue.withValues(alpha: 0.05),
                  leading: CircleAvatar(
                    backgroundColor: notif.isRead
                        ? Colors.grey.shade300
                        : AppColors.amber,
                    child: Icon(
                      Icons.notifications,
                      color: notif.isRead ? Colors.grey.shade600 : Colors.white,
                    ),
                  ),
                  title: Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notif.body),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                          'id_ID',
                        ).format(notif.createdAt.toLocal()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!notif.isRead) {
                      context.read<NotificationCubit>().markAsRead(notif.id);
                    }
                    if (notif.reportId != null) {
                      context.push('/reports/${notif.reportId}');
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
