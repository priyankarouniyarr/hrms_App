import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HosptialCodeStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Store base URL securely
  Future<void> storeBaseUrl(String baseUrl) async {
    await _secureStorage.write(key: 'base_url', value: baseUrl);
  }

  // Retrieve base URL securely
  Future<String?> getBaseUrl() async {
    try {
      return await _secureStorage.read(key: 'base_url');
    } catch (e) {
      print("Error reading base URL: $e");
      return null;
    }
  }

  // Remove base URL
  Future<void> removeBaseUrl() async {
    await _secureStorage.delete(key: 'base_url');
  }

  // Store hospital code securely
  Future<void> storeHospitalCode(String hospitalCode) async {
    await _secureStorage.write(key: 'hospital_code', value: hospitalCode);
  }

// Retrieve hospital code securely
  Future<String?> getHospitalCode() async {
    try {
      return await _secureStorage.read(key: 'hospital_code');
    } catch (e) {
      print("Error reading hospital code: $e");
      return null;
    }
  }

  Future<void> removeHospitalCode() async {
    await _secureStorage.delete(key: 'hospital_code');
  }
}
