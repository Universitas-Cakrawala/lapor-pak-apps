import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_pak_app/shared/models/user_model.dart';
import 'package:lapor_pak_app/shared/models/report_model.dart';
import 'package:lapor_pak_app/shared/models/status_history_model.dart';
import 'package:lapor_pak_app/shared/models/dashboard_stats.dart';

void main() {
  group('Model fromJson Tests', () {
    test('UserModel parses partial user correctly (login response)', () {
      final json = {
        "id": "u-123",
        "username": "tester",
        "fullName": "Tester User",
        "email": "test@test.com",
        "phone": "08123456789",
        "role": "PELAPOR"
      };

      final user = UserModel.fromJson(json);

      expect(user.id, "u-123");
      expect(user.role, UserRole.PELAPOR);
      expect(user.instansi, isNull);
      expect(user.createdAt, isNull);
    });

    test('ReportModel parses partial user in relation correctly', () {
      final json = {
        "id": "r-123",
        "roadName": "Jalan Rusak",
        "description": "Berlubang",
        "latitude": -6.2,
        "longitude": 106.8,
        "photoUrls": ["foto1.jpg"],
        "status": "MENUNGGU",
        "createdAt": "2023-10-01T10:00:00.000Z",
        "updatedAt": "2023-10-01T10:00:00.000Z",
        "user": {
          "id": "u-1",
          "fullName": "Budi",
          "phone": "0811"
        }
      };

      final report = ReportModel.fromJson(json);

      expect(report.id, "r-123");
      expect(report.status, ReportStatus.MENUNGGU);
      expect(report.user?.id, "u-1");
      expect(report.user?.phone, "0811");
      expect(report.user?.email, isNull);
    });

    test('DashboardStats parses totalLaporan correctly', () {
      final json = {
        "totalLaporan": 10,
        "menunggu": 2,
        "diproses": 5,
        "selesai": 3
      };

      final stats = DashboardStats.fromJson(json);

      expect(stats.totalLaporan, 10);
      expect(stats.menunggu, 2);
    });
  });
}
