import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/screen/branch_id.dart';
import 'package:hrms_app/models/loginscreen_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _token; // Store the token in memory

  final FlutterSecureStorage _secureStorage =
      FlutterSecureStorage(); // Secure storage instance

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get token => _token;

  // ✅ Login Method with Secure Token Storage
  Future<void> login(
      String username, String password, BuildContext context) async {
    _setLoading(true);

    if (username.isEmpty || password.isEmpty) {
      _setLoading(false);
      _setErrorMessage("Please enter both username and password");
      return;
    }

    try {
      LoginScreenModel loginModel = LoginScreenModel(
        username: username,
        password: password,
      );

      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/Account/LoginUser/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(loginModel.toJson()),
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final refreshToken = responseData['refreshToken'];

        print('Token: $token');
        print('RefreshToken: $refreshToken');

        // Store tokens securely
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);

        _token = token;
        notifyListeners();

        //Navigate to another screen (Uncomment if needed)
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectBranchScreen()));
      } else {
        _setErrorMessage("Invalid username or password");
      }
    } catch (e) {
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Retrieve Token Securely
  Future<void> loadToken() async {
    _token = await _secureStorage.read(key: 'auth_token');
    notifyListeners();
  }

  //  (Remove Token)
  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'refresh_token');
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
