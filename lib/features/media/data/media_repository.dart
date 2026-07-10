import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MediaRepository {
  final Dio dio;
  
  MediaRepository(this.dio);

  /// POST /media/upload → envelope { statusCode: 201, message, data: { urls: [...] } }
  Future<List<String>> upload(List<XFile> files) async {
    if (files.isEmpty) return [];

    final formData = FormData();
    for (final f in files) {
      if (kIsWeb) {
        final bytes = await f.readAsBytes();
        formData.files.add(MapEntry('files', MultipartFile.fromBytes(bytes, filename: f.name)));
      } else {
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(f.path, filename: f.name)));
      }
    }
    
    final res = await dio.post('/media/upload', data: formData);
    final data = extractData(res);
    return List<String>.from(data['urls']);
  }
}
