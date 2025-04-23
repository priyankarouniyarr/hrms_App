import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Store access token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Retrieve access token securely with try-catch
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      print("Error reading auth token: $e");
      return null;
    }
  }

  // Remove access token securely
  Future<void> removeToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Store refresh token securely
  Future<void> storeRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Retrieve refresh token securely with try-catch
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      print("Error reading refresh token: $e");
      return null;
    }
  }

  // Remove refresh token securely
  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  // Store username
  Future<void> storeUsername(String username) async {
    await _secureStorage.write(key: 'username', value: username);
  }

  // Retrieve username securely with try-catch
  Future<String?> getUsername() async {
    try {
      return await _secureStorage.read(key: 'username');
    } catch (e) {
      return null;
    }
  }
}
