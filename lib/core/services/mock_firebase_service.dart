// Mock Firebase service for development without actual Firebase setup
// This allows the app to run and be tested without Firebase configuration

class MockFirebaseService {
  static bool get isInitialized => true;
  
  static Future<void> initialize() async {
    // Mock initialization
    await Future.delayed(const Duration(milliseconds: 100));
  }
}