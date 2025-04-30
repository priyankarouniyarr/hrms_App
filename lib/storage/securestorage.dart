import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hrms_app/providers/notifications/notification_provider.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Write data to secure storage
  Future<void> writeData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      print('Error writing $key to secure storage: $e');
    }
  }

  // Read data from secure storage
  Future<String?> readData(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      print('Error reading $key from secure storage: $e');
      return null;
    }
  }

  // Delete data from secure storage
  Future<void> deleteData(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      print('Error deleting $key from secure storage: $e');
    }
  }
  // Fetch the FCM token
}
