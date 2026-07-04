import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class MediaHelper {
  // Base URL fallback if running locally
  static const String _defaultBaseUrl = 'http://10.0.2.2:3000/api';
  
  // NFR: 2MB limit (in bytes)
  static const int _maxImageBytes = 2 * 1024 * 1024;
  
  // Video < 10MB
  static const int maxVideoBytes = 10 * 1024 * 1024;

  /// Construct ready-to-use URL for Image.network
  static String displayUrl(String key) {
    // We should ideally get baseUrl from ApiConfig. 
    // Assuming it's standard local dev format for now.
    // If ApiConfig exists and is accessible, we could use that.
    return '$_defaultBaseUrl/media/$key';
  }

  /// Compress image iteratively to be under 2MB
  static Future<File> compressImage(File file) async {
    int length = file.lengthSync();
    if (length <= _maxImageBytes) return file;

    debugPrint('Original image size: ${length / 1024 / 1024} MB');
    
    int quality = 80;
    File? resultFile;
    
    // Create temporary path
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Loop quality: 80 -> 60 -> 40
    for (int i = 0; i < 3; i++) {
      final xFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
        minWidth: 1280,
        minHeight: 1280,
      );

      if (xFile != null) {
        resultFile = File(xFile.path);
        final compressedLength = resultFile.lengthSync();
        debugPrint('Compressed size at Q=$quality: ${compressedLength / 1024 / 1024} MB');
        
        if (compressedLength <= _maxImageBytes) {
          break; // Satisfies requirement
        }
      }
      quality -= 20;
    }

    return resultFile ?? file;
  }
}
