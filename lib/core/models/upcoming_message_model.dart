import 'package:equatable/equatable.dart';

class UpcomingMessageModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime showDate;
  final bool isActive;
  final DateTime createdAt;

  const UpcomingMessageModel({
    required this.id,
    required this.title,
    required this.message,
    required this.showDate,
    this.isActive = true,
    required this.createdAt,
  });

  factory UpcomingMessageModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMessageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      showDate: DateTime.parse(json['showDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'showDate': showDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get shouldShow => isActive && DateTime.now().isAfter(showDate);

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        showDate,
        isActive,
        createdAt,
      ];
}
