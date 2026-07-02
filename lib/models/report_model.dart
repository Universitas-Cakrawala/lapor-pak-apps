class ReportModel {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.createdAt,
  });

  // Convert a ReportModel to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a ReportModel from a JSON Map
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
