import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _envUrl = String.fromEnvironment('API_URL');
  
  static String get baseUrl {
    if (_envUrl.isNotEmpty) {
      return _envUrl;
    }
    // Jika berjalan di Web (Chrome), gunakan localhost.
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    // Jika berjalan di Android Emulator, gunakan 10.0.2.2.
    return 'http://10.0.2.2:3000/api';
  }
}
