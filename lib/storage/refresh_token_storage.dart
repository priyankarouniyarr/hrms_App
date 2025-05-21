import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RefreshTokenStorage {
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      print("Error reading refresh token: $e");
      return null;
    }
  }

  // Store refresh token securely
  Future<void> storeRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    print("refreshToken1: $refreshToken");
  }

  // Remove refresh token securely
  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
}
