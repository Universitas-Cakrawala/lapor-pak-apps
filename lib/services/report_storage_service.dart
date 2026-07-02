import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';

class ReportStorageService {
  // Get directory for saving images
  Future<Directory> _getImagesDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(docsDir.path, 'lapor_pak', 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  // Get file for saving structured report JSON data
  Future<File> _getDataFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dataDir = Directory(p.join(docsDir.path, 'lapor_pak', 'data'));
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return File(p.join(dataDir.path, 'reports.json'));
  }

  // Load all reports from local JSON
  Future<List<ReportModel>> loadReports() async {
    try {
      final file = await _getDataFile();
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
      return jsonList
          .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
    } catch (e) {
      // Return empty list on any error to prevent app crash
      debugPrint('Error loading reports: $e');
      return [];
    }
  }

  // Save a new report with image and text
  Future<ReportModel> saveReport({
    required String title,
    required String description,
    required File imageFile,
  }) async {
    // 1. Copy image to persistent application documents directory
    final imagesDir = await _getImagesDirectory();
    final String extension = p.extension(imageFile.path);
    final String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}$extension';
    final String newPath = p.join(imagesDir.path, fileName);
    
    // Copy the file
    final File savedImage = await imageFile.copy(newPath);

    // 2. Create the model
    final ReportModel newReport = ReportModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      imagePath: savedImage.path,
      createdAt: DateTime.now(),
    );

    // 3. Load existing, append, and save
    final reports = await loadReports();
    reports.add(newReport);

    final file = await _getDataFile();
    final jsonString = jsonEncode(reports.map((r) => r.toJson()).toList());
    await file.writeAsString(jsonString);

    return newReport;
  }

  // Delete a report and its associated image file
  Future<void> deleteReport(String id) async {
    try {
      final reports = await loadReports();
      final index = reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        final reportToDelete = reports[index];
        
        // Try deleting the image file
        final imageFile = File(reportToDelete.imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }

        // Remove from list and save updated list
        reports.removeAt(index);
        final file = await _getDataFile();
        final jsonString = jsonEncode(reports.map((r) => r.toJson()).toList());
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      debugPrint('Error deleting report: $e');
    }
  }
}
