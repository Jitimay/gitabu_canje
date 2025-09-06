import 'package:equatable/equatable.dart';
import '../../../core/models/book_model.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class BooksLoadRequested extends BooksEvent {
  final String? genre;
  final String? language;
  final String? authorId;
  final String? searchQuery;
  final int page;

  const BooksLoadRequested({
    this.genre,
    this.language,
    this.authorId,
    this.searchQuery,
    this.page = 1,
  });

  @override
  List<Object?> get props => [genre, language, authorId, searchQuery, page];
}

class BooksRefreshRequested extends BooksEvent {}

class BookUploadRequested extends BooksEvent {
  final String title;
  final String description;
  final String genre;
  final String language;
  final double price;
  final String pdfPath;
  final String? coverImagePath;
  final List<String> tags;

  const BookUploadRequested({
    required this.title,
    required this.description,
    required this.genre,
    required this.language,
    required this.price,
    required this.pdfPath,
    this.coverImagePath,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
        title,
        description,
        genre,
        language,
        price,
        pdfPath,
        coverImagePath,
        tags,
      ];
}

class BookPrecommandRequested extends BooksEvent {
  final String title;
  final String description;
  final String genre;
  final String language;
  final double price;
  final DateTime releaseDate;
  final String? coverImagePath;
  final List<String> tags;

  const BookPrecommandRequested({
    required this.title,
    required this.description,
    required this.genre,
    required this.language,
    required this.price,
    required this.releaseDate,
    this.coverImagePath,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
        title,
        description,
        genre,
        language,
        price,
        releaseDate,
        coverImagePath,
        tags,
      ];
}

class BookDeleteRequested extends BooksEvent {
  final String bookId;

  const BookDeleteRequested(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class BookDownloadRequested extends BooksEvent {
  final BookModel book;

  const BookDownloadRequested(this.book);

  @override
  List<Object> get props => [book];
}

class UpcomingMessagesLoadRequested extends BooksEvent {}

class UpcomingMessageAddRequested extends BooksEvent {
  final String title;
  final String message;
  final DateTime showDate;

  const UpcomingMessageAddRequested({
    required this.title,
    required this.message,
    required this.showDate,
  });

  @override
  List<Object> get props => [title, message, showDate];
}