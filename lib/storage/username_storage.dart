import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsernameStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
// Store username
  Future<void> storeUsername(String username) async {
    await _secureStorage.write(key: 'username', value: username);
  }

  //remove the username
  Future<void> removeUsername() async {
    await _secureStorage.delete(key: 'username');
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
