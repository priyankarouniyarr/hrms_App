import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Store access token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Retrieve access token securely
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Remove access token securely
  Future<void> removeToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Store refresh token securely
  Future<void> storeRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Retrieve refresh token securely
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Remove refresh token securely
  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }
}
