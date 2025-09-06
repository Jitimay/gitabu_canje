import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Igitabu';
  static const String appVersion = '1.0.0';
  
  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fr', 'FR'), // French
    Locale('rn', 'BI'), // Kirundi
  ];
  
  // Book genres
  static const List<String> bookGenres = [
    'Fiction',
    'Non-Fiction',
    'Poetry',
    'History',
    'Education',
    'Children',
    'Romance',
    'Mystery',
    'Biography',
    'Science',
    'Religion',
    'Politics',
  ];
  
  // Supported languages for books
  static const List<String> bookLanguages = [
    'Kirundi',
    'French',
    'English',
  ];
  
  // File size limits
  static const int maxPdfSizeMB = 50;
  static const int maxImageSizeMB = 5;
  
  // Pagination
  static const int booksPerPage = 20;
  static const int reviewsPerPage = 10;
  
  // Cache settings
  static const Duration cacheExpiry = Duration(hours: 24);
}