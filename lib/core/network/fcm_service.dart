import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../features/users/data/users_repository.dart';

class FcmService {
  static Future<void> setupPushNotifications(UsersRepository repo, GoRouter router) async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Minta izin
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Ambil token
        final token = await messaging.getToken();
        if (token != null) {
          await repo.updateFcmToken(token);
        }

        // Listener saat app di-foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // TODO: Tampilkan in-app notification/snackbar (Misalnya melalui global key scaffold messenger)
        });

        // Listener saat notifikasi diklik dan app dibuka dari background
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          final reportId = message.data['reportId'];
          if (reportId != null) {
            router.go('/reports/$reportId');
          }
        });
      }
    } catch (e) {
      // Abaikan jika firebase belum terkonfigurasi (google-services.json belum ada)
      debugPrint('FCM Setup Error: $e');
    }
  }
}
