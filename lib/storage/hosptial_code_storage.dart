import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HosptialCodeStorage {
  // Store hospital code securely
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
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
