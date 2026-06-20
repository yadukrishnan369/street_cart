import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyDwNtz3GP_5aUt-1ldGjO_tLZ0P57T-bf4',
            appId: '1:274190319065:web:5ee7f6fa0de6e30b6a6dc8', // Web App ID placeholder based on project number
            messagingSenderId: '274190319065',
            projectId: 'street-cart-57dc1',
            storageBucket: 'street-cart-57dc1.firebasestorage.app',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
      debugPrint("Firebase initialized successfully.");
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
      rethrow;
    }
  }
}
