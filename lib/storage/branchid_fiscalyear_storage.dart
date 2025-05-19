import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BranchidFiscalyearStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Store branch ID securely
  Future<void> storeWorkingBranchid(String branchId) async {
    await _secureStorage.write(
        key: 'selected_workingbranchId', value: branchId);
  }

  // Retrieve branch ID securely
  Future<String?> getBranchId() async {
    try {
      return await _secureStorage.read(key: 'selected_workingbranchId');
    } catch (e) {
      print("Error reading branch ID: $e");
      return null;
    }
  }

  Future<void> storeBranchIdAndFiscalYearId(String fiscalyear) async {
    await _secureStorage.write(key: 'selected_fiscal_year', value: fiscalyear);
  }

  Future<String?> getBranchIdAndFiscalYearId() async {
    try {
      return await _secureStorage.read(key: 'selected_fiscal_year');
    } catch (e) {
      print("Error reading branch ID: $e");
      return null;
    }
  }

  Future<void> removeBranchId() async {
    await _secureStorage.delete(key: 'selected_workingbranchId');
  }

  Future<void> removeBranchIdAndFiscalYearId() async {
    await _secureStorage.delete(key: 'selected_fiscal_year');
  }
}
