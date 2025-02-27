import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// secure_storage_service.dart

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Write data to secure storage
  Future<void> writeData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Read data from secure storage
  Future<String?> readData(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Delete data from secure storage
  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }
}
