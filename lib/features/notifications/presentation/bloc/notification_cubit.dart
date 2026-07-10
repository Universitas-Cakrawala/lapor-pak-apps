import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/models/notification_model.dart';
import '../../data/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(const NotificationState());

  Future<void> fetchNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final notifications = await repository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await repository.markAsRead(id);
      
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == id) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            title: n.title,
            body: n.body,
            isRead: true,
            reportId: n.reportId,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      // Handle error implicitly or add some error state logic
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      
      final updatedNotifications = state.notifications.map((n) {
        return NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          body: n.body,
          isRead: true,
          reportId: n.reportId,
          createdAt: n.createdAt,
        );
      }).toList();

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      ));
    } catch (e) {
      // Error handling
    }
  }
}
