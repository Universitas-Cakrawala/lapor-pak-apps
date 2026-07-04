import 'package:equatable/equatable.dart';

class ReportStatsSummary extends Equatable {
  final int total;
  final int menunggu;
  final int diproses;
  final int selesai;

  const ReportStatsSummary({
    required this.total,
    required this.menunggu,
    required this.diproses,
    required this.selesai,
  });

  factory ReportStatsSummary.fromJson(Map<String, dynamic> json) => ReportStatsSummary(
    total: json['total'] ?? 0,
    menunggu: json['menunggu'] ?? 0,
    diproses: json['diproses'] ?? 0,
    selesai: json['selesai'] ?? 0,
  );

  @override
  List<Object?> get props => [total, menunggu, diproses, selesai];
}
