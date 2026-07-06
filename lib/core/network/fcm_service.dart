import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../../features/users/data/users_repository.dart';

class FcmService {
  static Future<void> setupPushNotifications(
    UsersRepository repo,
    GoRouter router,
  ) async {
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
          final title = message.notification?.title ?? 'Notifikasi Baru';
          final body = message.notification?.body ?? '';

          final overlay = rootNavigatorKey.currentState?.overlay;
          if (overlay == null) {
            // Fallback ke bottom snackbar jika overlay tidak ditemukan
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text('$title\n$body'),
                action: SnackBarAction(
                  label: 'Lihat',
                  onPressed: () {
                    final reportId = message.data['reportId'];
                    if (reportId != null) router.go('/reports/$reportId');
                  },
                ),
              ),
            );
            return;
          }

          late OverlayEntry entry;
          entry = OverlayEntry(
            builder: (context) => Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  16, // Aman dari notch/status bar
              left: 16,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF323232),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            if (body.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                body,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (entry.mounted) entry.remove();
                          final reportId = message.data['reportId'];
                          if (reportId != null) router.go('/reports/$reportId');
                        },
                        child: const Text(
                          'LIHAT',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          overlay.insert(entry);
          Future.delayed(const Duration(seconds: 5), () {
            if (entry.mounted) entry.remove();
          });
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
