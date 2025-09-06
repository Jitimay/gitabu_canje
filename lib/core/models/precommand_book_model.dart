import 'package:equatable/equatable.dart';

class PrecommandBookModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String genre;
  final String language;
  final double price;
  final DateTime releaseDate;
  final String? coverImageUrl;
  final List<String> tags;
  final int preorders;
  final DateTime createdAt;

  const PrecommandBookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.genre,
    required this.language,
    required this.price,
    required this.releaseDate,
    this.coverImageUrl,
    this.tags = const [],
    this.preorders = 0,
    required this.createdAt,
  });

  factory PrecommandBookModel.fromJson(Map<String, dynamic> json) {
    return PrecommandBookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      genre: json['genre'] as String,
      language: json['language'] as String,
      price: (json['price'] as num).toDouble(),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      coverImageUrl: json['coverImageUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      preorders: json['preorders'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'genre': genre,
      'language': language,
      'price': price,
      'releaseDate': releaseDate.toIso8601String(),
      'coverImageUrl': coverImageUrl,
      'tags': tags,
      'preorders': preorders,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        authorId,
        authorName,
        genre,
        language,
        price,
        releaseDate,
        coverImageUrl,
        tags,
        preorders,
        createdAt,
      ];
}
