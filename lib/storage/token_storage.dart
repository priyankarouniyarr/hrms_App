import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Store access token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Retrieve access token securely with try-catch
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      // print("Error reading auth token: $e");
      return null;
    }
  }

// Remove access token securely
  Future<void> removeToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
