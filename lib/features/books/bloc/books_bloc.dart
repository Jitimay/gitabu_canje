import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import '../../../core/models/book_model.dart';
import '../../../core/models/precommand_book_model.dart';
import '../../../core/models/upcoming_message_model.dart';
import '../../../core/config/app_config.dart';
import 'books_event.dart';
import 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Dio _dio;

  BooksBloc({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Dio? dio,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _dio = dio ?? Dio(),
        super(const BooksState()) {
    on<BooksLoadRequested>(_onBooksLoadRequested);
    on<BooksRefreshRequested>(_onBooksRefreshRequested);
    on<BookUploadRequested>(_onBookUploadRequested);
    on<BookPrecommandRequested>(_onBookPrecommandRequested);
    on<BookDeleteRequested>(_onBookDeleteRequested);
    on<BookDownloadRequested>(_onBookDownloadRequested);
    on<UpcomingMessagesLoadRequested>(_onUpcomingMessagesLoadRequested);
    on<UpcomingMessageAddRequested>(_onUpcomingMessageAddRequested);
  }

  Future<void> _onBooksLoadRequested(
    BooksLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    if (event.page == 1) {
      emit(state.copyWith(
        status: BooksStatus.loading,
        currentGenre: event.genre,
        currentLanguage: event.language,
        currentSearchQuery: event.searchQuery,
        currentPage: 1,
      ));
    }

    try {
      Query query = _firestore
          .collection('books')
          .where('isActive', isEqualTo: true)
          .orderBy('publishedAt', descending: true);

      // Apply filters
      if (event.genre != null && event.genre!.isNotEmpty) {
        query = query.where('genre', isEqualTo: event.genre);
      }

      if (event.language != null && event.language!.isNotEmpty) {
        query = query.where('language', isEqualTo: event.language);
      }

      if (event.authorId != null && event.authorId!.isNotEmpty) {
        query = query.where('authorId', isEqualTo: event.authorId);
      }

      // Pagination
      query = query.limit(AppConfig.booksPerPage);
      if (event.page > 1) {
        final lastDoc = await _getLastDocument(event.page - 1);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();
      final books = querySnapshot.docs
          .map((doc) => BookModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      // Apply search filter locally (Firestore doesn't support full-text search)
      List<BookModel> filteredBooks = books;
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final searchLower = event.searchQuery!.toLowerCase();
        filteredBooks = books.where((book) {
          return book.title.toLowerCase().contains(searchLower) ||
              book.description.toLowerCase().contains(searchLower) ||
              book.authorName.toLowerCase().contains(searchLower) ||
              book.tags.any((tag) => tag.toLowerCase().contains(searchLower));
        }).toList();
      }

      final allBooks = event.page == 1
          ? filteredBooks
          : [...state.books, ...filteredBooks];

      emit(state.copyWith(
        status: BooksStatus.success,
        books: allBooks,
        hasReachedMax: filteredBooks.length < AppConfig.booksPerPage,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: 'Failed to load books: ${e.toString()}',
      ));
    }
  }

  Future<void> _onBooksRefreshRequested(
    BooksRefreshRequested event,
    Emitter<BooksState> emit,
  ) async {
    add(BooksLoadRequested(
      genre: state.currentGenre,
      language: state.currentLanguage,
      searchQuery: state.currentSearchQuery,
      page: 1,
    ));
  }

  Future<void> _onBookUploadRequested(
    BookUploadRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(state.copyWith(status: BooksStatus.loading));

    try {
      // Upload PDF
      final pdfFile = File(event.pdfPath);
      final pdfFileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfRef = _storage.ref().child('books/pdfs/$pdfFileName');
      await pdfRef.putFile(pdfFile);
      final pdfUrl = await pdfRef.getDownloadURL();

      // Upload cover image if provided
      String? coverImageUrl;
      if (event.coverImagePath != null) {
        final imageFile = File(event.coverImagePath!);
        final imageFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final imageRef = _storage.ref().child('books/covers/$imageFileName');
        await imageRef.putFile(imageFile);
        coverImageUrl = await imageRef.getDownloadURL();
      }

      // Create book document
      final bookRef = _firestore.collection('books').doc();
      final now = DateTime.now();

      final book = BookModel(
        id: bookRef.id,
        title: event.title,
        description: event.description,
        authorId: 'current_user_id', // TODO: Get from auth
        authorName: 'Current User', // TODO: Get from auth
        genre: event.genre,
        language: event.language,
        price: event.price,
        coverImageUrl: coverImageUrl,
        pdfUrl: pdfUrl,
        tags: event.tags,
        publishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await bookRef.set(book.toJson());

      // Refresh books list
      add(BooksRefreshRequested());
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: 'Failed to upload book: ${e.toString()}',
      ));
    }
  }

  Future<void> _onBookDeleteRequested(
    BookDeleteRequested event,
    Emitter<BooksState> emit,
  ) async {
    try {
      await _firestore
          .collection('books')
          .doc(event.bookId)
          .update({'isActive': false});

      // Remove from local list
      final updatedBooks = state.books
          .where((book) => book.id != event.bookId)
          .toList();

      emit(state.copyWith(books: updatedBooks));
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: 'Failed to delete book: ${e.toString()}',
      ));
    }
  }

  Future<void> _onBookDownloadRequested(
    BookDownloadRequested event,
    Emitter<BooksState> emit,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${event.book.id}.pdf';

      await _dio.download(event.book.pdfUrl, filePath);

      // Update download count
      await _firestore
          .collection('books')
          .doc(event.book.id)
          .update({'downloadCount': FieldValue.increment(1)});

      // Add to downloaded books
      final updatedDownloadedBooks = [...state.downloadedBooks, event.book];
      emit(state.copyWith(downloadedBooks: updatedDownloadedBooks));
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: 'Failed to download book: ${e.toString()}',
      ));
    }
  }

  Future<void> _onBookPrecommandRequested(
    BookPrecommandRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(state.copyWith(status: BooksStatus.loading));

    try {
      String? coverImageUrl;
      if (event.coverImagePath != null) {
        final coverRef = _storage.ref().child('precommand_covers/${DateTime.now().millisecondsSinceEpoch}');
        await coverRef.putFile(File(event.coverImagePath!));
        coverImageUrl = await coverRef.getDownloadURL();
      }

      final precommandBook = PrecommandBookModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        authorId: 'demo_author',
        authorName: 'Demo Author',
        genre: event.genre,
        language: event.language,
        price: event.price,
        releaseDate: event.releaseDate,
        coverImageUrl: coverImageUrl,
        tags: event.tags,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('precommand_books')
          .doc(precommandBook.id)
          .set(precommandBook.toJson());

      final updatedPrecommands = List<PrecommandBookModel>.from(state.precommandBooks)
        ..add(precommandBook);

      emit(state.copyWith(
        status: BooksStatus.success,
        precommandBooks: updatedPrecommands,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: 'Failed to create precommand: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpcomingMessagesLoadRequested(
    UpcomingMessagesLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('upcoming_messages')
          .where('isActive', isEqualTo: true)
          .orderBy('showDate', descending: false)
          .get();

      final messages = snapshot.docs
          .map((doc) => UpcomingMessageModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      emit(state.copyWith(upcomingMessages: messages));
    } catch (e) {
      // Silently fail for messages
    }
  }

  Future<void> _onUpcomingMessageAddRequested(
    UpcomingMessageAddRequested event,
    Emitter<BooksState> emit,
  ) async {
    try {
      final message = UpcomingMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        message: event.message,
        showDate: event.showDate,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('upcoming_messages')
          .doc(message.id)
          .set(message.toJson());

      final updatedMessages = List<UpcomingMessageModel>.from(state.upcomingMessages)
        ..add(message);

      emit(state.copyWith(upcomingMessages: updatedMessages));
    } catch (e) {
      // Silently fail for messages
    }
  }

  Future<DocumentSnapshot?> _getLastDocument(int page) async {
    try {
      final query = _firestore
          .collection('books')
          .where('isActive', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .limit(AppConfig.booksPerPage * page);

      final snapshot = await query.get();
      return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    } catch (e) {
      return null;
    }
  }
}