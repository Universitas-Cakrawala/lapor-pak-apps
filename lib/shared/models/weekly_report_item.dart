import 'package:equatable/equatable.dart';

class WeeklyReportItem extends Equatable {
  final String weekStart;
  final String weekEnd;
  final String label;
  final int count;

  const WeeklyReportItem({
    required this.weekStart,
    required this.weekEnd,
    required this.label,
    required this.count,
  });

  factory WeeklyReportItem.fromJson(Map<String, dynamic> json) => WeeklyReportItem(
    weekStart: json['weekStart'] ?? '',
    weekEnd: json['weekEnd'] ?? '',
    label: json['label'] ?? '',
    count: json['count'] ?? 0,
  );

  @override
  List<Object?> get props => [weekStart, weekEnd, label, count];
}
