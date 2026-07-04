import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../media/utils/media_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class MediaPickerWidget extends StatefulWidget {
  final Function(List<File> photos, File? video) onMediaChanged;
  
  const MediaPickerWidget({super.key, required this.onMediaChanged});

  @override
  State<MediaPickerWidget> createState() => _MediaPickerWidgetState();
}

class _MediaPickerWidgetState extends State<MediaPickerWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];
  File? _video;

  Future<void> _pickPhoto(ImageSource source) async {
    if (_photos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maksimal 5 foto!')));
      return;
    }
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File finalFile;
        if (kIsWeb) {
          finalFile = File(pickedFile.path);
        } else {
          final tempDir = await getTemporaryDirectory();
          final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
          final safeFile = File('${tempDir.path}/$uniqueName');
          finalFile = await File(pickedFile.path).copy(safeFile.path);
        }
        setState(() {
          _photos.add(finalFile);
        });
        widget.onMediaChanged(_photos, _video);
      }
    } catch (e) {
      debugPrint('Error picking photo: $e');
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    if (_video != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maksimal 1 video!')));
      return;
    }
    try {
      final pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        File finalFile;
        if (kIsWeb) {
          finalFile = File(pickedFile.path);
        } else {
          final tempDir = await getTemporaryDirectory();
          final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
          final safeFile = File('${tempDir.path}/$uniqueName');
          finalFile = await File(pickedFile.path).copy(safeFile.path);
        }
        
        // Validasi ukuran video di klien (< 10MB)
        final int fileLength = kIsWeb ? (await finalFile.readAsBytes()).length : finalFile.lengthSync();
        if (fileLength > MediaHelper.maxVideoBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ukuran video tidak boleh lebih dari 10MB!'), backgroundColor: Colors.red),
            );
          }
          return;
        }
        setState(() {
          _video = finalFile;
        });
        widget.onMediaChanged(_photos, _video);
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onMediaChanged(_photos, _video);
  }

  void _removeVideo() {
    setState(() {
      _video = null;
    });
    widget.onMediaChanged(_photos, _video);
  }

  void _showSourceDialog(bool isVideo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                isVideo ? _pickVideo(ImageSource.camera) : _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                isVideo ? _pickVideo(ImageSource.gallery) : _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Foto Bukti Laporan', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('${_photos.length}/5', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._photos.asMap().entries.map((e) => _buildThumbnail(e.value, false, e.key)),
              if (_photos.length < 5)
                InkWell(
                  onTap: () => _showSourceDialog(false),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Icon(Icons.add_a_photo, color: AppColors.outline),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Video Kejadian (Opsional)', style: TextStyle(fontWeight: FontWeight.w600)),
            Text(_video != null ? '1/1' : '0/1', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        if (_video != null)
          _buildThumbnail(_video!, true, 0)
        else
          InkWell(
            onTap: () => _showSourceDialog(true),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_call, color: AppColors.civicBlue),
                  SizedBox(width: 8),
                  Text('Pilih Video (Maks 10MB)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget _buildThumbnail(File file, bool isVideo, int index) {
    return Container(
      width: isVideo ? 120 : 80,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black12,
              image: isVideo
                  ? null
                  : DecorationImage(
                      image: kIsWeb ? NetworkImage(file.path) as ImageProvider : FileImage(file),
                      fit: BoxFit.cover,
                    ),
            ),
            child: isVideo ? VideoThumbnailWidget(file: file) : null,
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => isVideo ? _removeVideo() : _removePhoto(index),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final File file;
  const VideoThumbnailWidget({super.key, required this.file});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(widget.file.path))
        : VideoPlayerController.file(widget.file);
        
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }).catchError((_) {
      // Ignore initialization errors
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: Icon(Icons.videocam, size: 40, color: Colors.grey),
      );
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          Container(
            color: Colors.black26,
            child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
