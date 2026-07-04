import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MediaRepository {
  final Dio dio;
  
  MediaRepository(this.dio);

  /// POST /media/upload → envelope { statusCode: 201, message, data: { urls: [...] } }
  Future<List<String>> upload(List<File> files) async {
    if (files.isEmpty) return [];

    final formData = FormData();
    for (final f in files) {
      if (kIsWeb) {
        final bytes = await f.readAsBytes();
        final filename = f.path.split('/').last;
        formData.files.add(MapEntry('files', MultipartFile.fromBytes(bytes, filename: filename)));
      } else {
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(f.path)));
      }
    }
    
    final res = await dio.post('/media/upload', data: formData);
    final data = extractData(res);
    return List<String>.from(data['urls']);
  }
}
