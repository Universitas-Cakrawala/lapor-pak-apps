import 'package:dio/dio.dart';
import '../../../shared/models/notification_model.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository(this.dio);

  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get('/notifications');
    final List<dynamic> data = response.data['data'];
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<void> markAsRead(String id) async {
    await dio.patch('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await dio.patch('/notifications/read-all');
  }
}
