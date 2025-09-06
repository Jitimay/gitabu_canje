import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String genre;
  final String language;
  final double price;
  final String? coverImageUrl;
  final String pdfUrl;
  final String? audioUrl;
  final int downloadCount;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const BookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.genre,
    required this.language,
    required this.price,
    this.coverImageUrl,
    required this.pdfUrl,
    this.audioUrl,
    this.downloadCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  bool get isFree => price == 0.0;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasCustomCover => coverImageUrl != null && coverImageUrl!.isNotEmpty;

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      genre: json['genre'] as String,
      language: json['language'] as String,
      price: (json['price'] as num).toDouble(),
      coverImageUrl: json['coverImageUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String,
      audioUrl: json['audioUrl'] as String?,
      downloadCount: json['downloadCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List? ?? []),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
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
      'coverImageUrl': coverImageUrl,
      'pdfUrl': pdfUrl,
      'audioUrl': audioUrl,
      'downloadCount': downloadCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'publishedAt': publishedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? authorId,
    String? authorName,
    String? genre,
    String? language,
    double? price,
    String? coverImageUrl,
    String? pdfUrl,
    String? audioUrl,
    int? downloadCount,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      price: price ?? this.price,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      downloadCount: downloadCount ?? this.downloadCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
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
        coverImageUrl,
        pdfUrl,
        audioUrl,
        downloadCount,
        rating,
        reviewCount,
        tags,
        publishedAt,
        createdAt,
        updatedAt,
        isActive,
      ];
}