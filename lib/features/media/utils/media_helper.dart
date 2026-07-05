import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/config/api_config.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class MediaHelper {
  // NFR: 2MB limit (in bytes)
  static const int _maxImageBytes = 2 * 1024 * 1024;
  
  // Video < 50MB
  static const int maxVideoBytes = 50 * 1024 * 1024;

  static String displayUrl(String key) {
    return '${ApiConfig.baseUrl}/media/$key';
  }

  /// Compress image iteratively to be under 2MB
  static Future<File> compressImage(File file) async {
    if (kIsWeb) return file; // Skip compression on Web to avoid dart:io File exceptions

    int length = file.lengthSync();
    if (length <= _maxImageBytes) return file;

    debugPrint('Original image size: ${length / 1024 / 1024} MB');
    
    int quality = 80;
    File? resultFile;
    
    // Create temporary path
    final dir = await getTemporaryDirectory();
    final uniqueId = '${DateTime.now().millisecondsSinceEpoch}_${file.path.hashCode}';
    final targetPath = '${dir.path}/temp_$uniqueId.jpg';

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
