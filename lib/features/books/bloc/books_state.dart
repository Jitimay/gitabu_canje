import 'package:equatable/equatable.dart';
import '../../../core/models/book_model.dart';
import '../../../core/models/precommand_book_model.dart';
import '../../../core/models/upcoming_message_model.dart';

enum BooksStatus { initial, loading, success, failure }

class BooksState extends Equatable {
  final BooksStatus status;
  final List<BookModel> books;
  final List<BookModel> downloadedBooks;
  final List<PrecommandBookModel> precommandBooks;
  final List<UpcomingMessageModel> upcomingMessages;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentGenre;
  final String? currentLanguage;
  final String? currentSearchQuery;

  const BooksState({
    this.status = BooksStatus.initial,
    this.books = const [],
    this.downloadedBooks = const [],
    this.precommandBooks = const [],
    this.upcomingMessages = const [],
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentGenre,
    this.currentLanguage,
    this.currentSearchQuery,
  });

  BooksState copyWith({
    BooksStatus? status,
    List<BookModel>? books,
    List<BookModel>? downloadedBooks,
    List<PrecommandBookModel>? precommandBooks,
    List<UpcomingMessageModel>? upcomingMessages,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
    String? currentGenre,
    String? currentLanguage,
    String? currentSearchQuery,
  }) {
    return BooksState(
      status: status ?? this.status,
      books: books ?? this.books,
      downloadedBooks: downloadedBooks ?? this.downloadedBooks,
      precommandBooks: precommandBooks ?? this.precommandBooks,
      upcomingMessages: upcomingMessages ?? this.upcomingMessages,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentGenre: currentGenre ?? this.currentGenre,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  bool get isLoading => status == BooksStatus.loading;
  bool get isSuccess => status == BooksStatus.success;
  bool get isFailure => status == BooksStatus.failure;
  bool get isEmpty => books.isEmpty && status == BooksStatus.success;

  List<UpcomingMessageModel> get activeMessages => 
      upcomingMessages.where((msg) => msg.shouldShow).toList();

  @override
  List<Object?> get props => [
        status,
        books,
        downloadedBooks,
        precommandBooks,
        upcomingMessages,
        errorMessage,
        hasReachedMax,
        currentPage,
        currentGenre,
        currentLanguage,
        currentSearchQuery,
      ];
}