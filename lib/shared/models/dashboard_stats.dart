import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalLaporan;
  final int menunggu;
  final int diproses;
  final int selesai;

  const DashboardStats({
    required this.totalLaporan,
    required this.menunggu,
    required this.diproses,
    required this.selesai,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    totalLaporan: json['totalLaporan'] ?? 0,
    menunggu: json['menunggu'] ?? 0,
    diproses: json['diproses'] ?? 0,
    selesai: json['selesai'] ?? 0,
  );

  @override
  List<Object?> get props => [totalLaporan, menunggu, diproses, selesai];
}
