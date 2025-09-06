# Igitabu - Burundian Digital Library 📚

A production-ready Flutter application for digital library management where authors can publish books and readers can access them. Built with BLoC state management and Firebase backend.

## 🌟 Features

### 📱 Core Features
- **Cross-platform**: Android & iOS support
- **Authentication**: Email/Password + Google Sign-in
- **User Roles**: Authors (publish books) & Readers (browse/read books)
- **Book Management**: Upload, browse, search, download books
- **Offline Reading**: Downloaded books available offline
- **Multi-language**: English, French, Kirundi support
- **Theme Support**: Light/Dark mode with system preference

### 👤 User Features
- **For Readers**:
  - Browse books by genre, language, author
  - Search functionality
  - Book details with ratings & reviews
  - Download for offline reading
  - Personal library management

- **For Authors**:
  - Upload books (PDF + cover image)
  - Set pricing (free or paid)
  - Book metadata management
  - Author profile pages

### 🎨 UI/UX
- Modern Material Design 3
- Responsive layouts
- Smooth animations
- Accessibility compliant
- Intuitive navigation

## 🏗️ Architecture

### BLoC State Management
```
lib/
├── core/
│   ├── bloc/
│   │   ├── theme/          # Theme management
│   │   ├── locale/         # Language management
│   │   └── app_bloc_providers.dart
│   ├── config/
│   ├── models/             # Data models
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── bloc/           # Authentication BLoC
│   │   └── pages/
│   ├── books/
│   │   ├── bloc/           # Books management BLoC
│   │   └── pages/
│   ├── home/
│   │   ├── pages/
│   │   └── widgets/
│   └── profile/
└── main.dart
```

### Key BLoCs
- **AuthBloc**: User authentication & session management
- **BooksBloc**: Book CRUD operations, search, filtering
- **ThemeBloc**: App theme management
- **LocaleBloc**: Language/localization management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.6.0)
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd igitabu
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase in your project
   firebase init
   
   # Generate Firebase configuration
   flutterfire configure
   ```

4. **Update Firebase Options**
   - Replace the placeholder values in `firebase_options.dart` with your actual Firebase configuration

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Services Required
- **Authentication**: Email/Password, Google Sign-in
- **Firestore Database**: Book and user data storage
- **Firebase Storage**: PDF files and cover images
- **Firebase Analytics** (optional): Usage tracking

### Firestore Collections Structure
```
users/
├── {userId}/
│   ├── id: string
│   ├── email: string
│   ├── displayName: string
│   ├── role: 'reader' | 'author'
│   └── ...

books/
├── {bookId}/
│   ├── title: string
│   ├── description: string
│   ├── authorId: string
│   ├── genre: string
│   ├── language: string
│   ├── price: number
│   ├── pdfUrl: string
│   ├── coverImageUrl?: string
│   └── ...

reviews/
├── {reviewId}/
│   ├── bookId: string
│   ├── userId: string
│   ├── rating: number
│   ├── comment: string
│   └── ...
```

## 📦 Key Dependencies

```yaml
dependencies:
  # Core
  flutter_bloc: ^8.1.6          # State management
  equatable: ^2.0.5             # Value equality
  
  # Firebase
  firebase_core: ^2.24.2        # Firebase core
  firebase_auth: ^4.15.3        # Authentication
  cloud_firestore: ^4.13.6      # Database
  firebase_storage: ^11.5.6     # File storage
  google_sign_in: ^6.2.1        # Google auth
  
  # UI & Navigation
  go_router: ^12.1.3            # Navigation
  cached_network_image: ^3.3.1  # Image caching
  flutter_svg: ^2.0.10          # SVG support
  
  # File Handling
  file_picker: ^6.1.1           # File selection
  flutter_pdfview: ^1.3.2       # PDF viewing
  path_provider: ^2.1.2         # File paths
  
  # Storage & Network
  shared_preferences: ^2.2.2    # Local storage
  dio: ^5.4.0                   # HTTP client
  
  # Internationalization
  flutter_localizations:        # Localization
    sdk: flutter
  intl: ^0.19.0                 # Internationalization
```

## 🌍 Internationalization

The app supports three languages:
- **English** (en_US) - Default
- **French** (fr_FR) - Français
- **Kirundi** (rn_BI) - Kirundi

### Adding New Languages
1. Add locale to `AppConfig.supportedLocales`
2. Create translation files in `lib/l10n/`
3. Update language selection UI

## 🎯 Usage Examples

### Authentication
```dart
// Sign in
context.read<AuthBloc>().add(AuthSignInRequested(
  email: 'user@example.com',
  password: 'password',
));

// Sign up as author
context.read<AuthBloc>().add(AuthSignUpRequested(
  email: 'author@example.com',
  password: 'password',
  displayName: 'Author Name',
  role: UserRole.author,
));
```

### Book Management
```dart
// Load books
context.read<BooksBloc>().add(BooksLoadRequested());

// Search books
context.read<BooksBloc>().add(BooksLoadRequested(
  searchQuery: 'flutter',
  genre: 'Technology',
));

// Upload book (authors only)
context.read<BooksBloc>().add(BookUploadRequested(
  title: 'My Book',
  description: 'Book description',
  genre: 'Fiction',
  language: 'English',
  price: 9.99,
  pdfPath: '/path/to/book.pdf',
));
```

## 🚧 Future Enhancements

### Planned Features
- **Audiobooks**: Upload and play audio versions
- **Subscription Model**: Monthly unlimited reading
- **Advanced Search**: Full-text search with filters
- **Social Features**: Follow authors, book clubs
- **Payment Integration**: Lumicash/Ecocash mobile money
- **Analytics Dashboard**: Author insights and statistics
- **Push Notifications**: New books, updates
- **Offline Sync**: Better offline experience

### Technical Improvements
- **Unit Tests**: Comprehensive test coverage
- **Integration Tests**: End-to-end testing
- **CI/CD Pipeline**: Automated builds and deployment
- **Performance Optimization**: Image compression, lazy loading
- **Security Enhancements**: Advanced authentication, data encryption

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow BLoC pattern for new features
4. Add tests for new functionality
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guide
- Use BLoC pattern for state management
- Write meaningful commit messages
- Add documentation for new features
- Ensure responsive design
- Test on both Android and iOS

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Burundian literary community for inspiration
- Open source contributors

## 📞 Support

For support, email support@igitabu.com or create an issue in the repository.

---

**Made with ❤️ for the Burundian literary community**
