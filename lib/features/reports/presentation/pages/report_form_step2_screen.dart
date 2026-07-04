import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/report_form_cubit.dart';
import '../bloc/report_form_state.dart';
import '../widgets/media_picker_widget.dart';

import '../../../../shared/models/report_model.dart';

class ReportFormStep2Screen extends StatefulWidget {
  final ReportModel? existingReport;
  const ReportFormStep2Screen({super.key, this.existingReport});

  @override
  State<ReportFormStep2Screen> createState() => _ReportFormStep2ScreenState();
}

class _ReportFormStep2ScreenState extends State<ReportFormStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _roadNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  
  // Media (Skill 06)
  List<File> _photos = [];
  File? _video;

  @override
  void initState() {
    super.initState();
    if (widget.existingReport != null) {
      _roadNameCtrl.text = widget.existingReport!.roadName;
      _descCtrl.text = widget.existingReport!.description;
      _currentLocation = LatLng(widget.existingReport!.latitude, widget.existingReport!.longitude);
      // Skip fetching new location since we have existing one
    } else {
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        )
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi belum ditemukan')));
      return;
    }

    if (widget.existingReport == null && _photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimal pilih 1 foto!')));
      return;
    }

    if (widget.existingReport != null) {
      context.read<ReportFormCubit>().updateReport(
        id: widget.existingReport!.id,
        roadName: _roadNameCtrl.text,
        description: _descCtrl.text,
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );
    } else {
      context.read<ReportFormCubit>().submitReport(
        roadName: _roadNameCtrl.text,
        description: _descCtrl.text,
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        photos: _photos,
        video: _video,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingReport != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Laporan' : 'Buat Laporan (2/2)'),
      ),
      body: BlocConsumer<ReportFormCubit, ReportFormState>(
        listener: (context, state) {
          if (state.status == ReportFormStatus.success) {
            context.go('/reports/success');
          } else if (state.status == ReportFormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Gagal submit'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _roadNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Jalan / Lokasi',
                      hintText: 'Cth: Jl. Sudirman depan halte',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Kerusakan',
                      hintText: 'Cth: Lubang besar di tengah jalan, berbahaya saat malam',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text('Titik Lokasi GPS', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.outline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _isLoadingLocation
                        ? const Center(child: CircularProgressIndicator())
                        : _currentLocation != null
                            ? FlutterMap(
                                options: MapOptions(
                                  initialCenter: _currentLocation!,
                                  initialZoom: 16.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.laporpak.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _currentLocation!,
                                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : Center(
                                child: TextButton(
                                  onPressed: _getLocation,
                                  child: const Text('Ambil Ulang Lokasi'),
                                ),
                              ),
                  ),
                  const SizedBox(height: 24),
                  if (!isEdit) ...[
                    MediaPickerWidget(
                      onMediaChanged: (photos, video) {
                        setState(() {
                          _photos = photos;
                          _video = video;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Media tidak dapat diubah pada mode edit.',
                              style: TextStyle(color: Colors.blue, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.status == ReportFormStatus.loading ? null : _submit,
                      child: state.status == ReportFormStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Kirim Laporan'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
