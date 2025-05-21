import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ExpirationtimeStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<void> removeExpirationTime() async {
    await _secureStorage.delete(key: 'expiration_time');
  }

//Stores the expiration time of the token
  Future<void> storeExpiationTime(DateTime time) async {
    await _secureStorage.write(
        key: 'expiration_time', value: time.toLocal().toIso8601String());
    print("expiration time1: $time");
    print("Expiration time stored successfully");
  }

  // Retrieves the expiration time of the token securely with try-catch
  Future<DateTime?> getExpirationtime() async {
    try {
      final response = await _secureStorage.read(key: 'expiration_time');
      if (response != null) {
        return DateTime.parse(response);
      }
    } catch (e) {
      print("Error reading expiration time: $e");
    }
    return null;
  }
}
