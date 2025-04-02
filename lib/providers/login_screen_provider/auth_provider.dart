import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/screen/branch_id.dart';
import 'package:hrms_app/models/login_screen_models/loginscreen_models.dart';
import 'package:hrms_app/storage/token_storage.dart'; // Import the TokenStorage

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _token;
  String? _username;
  int? _expirationTime; // Store expiration time

  final TokenStorage _tokenStorage = TokenStorage();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get token => _token;
  String? get username => _username;

//

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

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final refreshToken = responseData['refreshToken'];
        _expirationTime =
            responseData['expirationTime']; // Store expiration time

        _username = username;

        await _tokenStorage.storeToken(token);
        await _tokenStorage.storeUsername(username);
        await _tokenStorage.storeRefreshToken(refreshToken);

        _token = token;
        notifyListeners();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SelectBranchScreen()),
            (route) => false);
      } else {
        _setErrorMessage("Invalid username or password");
      }
    } catch (e) {
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Check if the token is expired
  bool isTokenExpired() {
    if (_expirationTime == null) return true;

    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    return currentTime > _expirationTime!;
  }

  // Load access token securely
  Future<void> loadToken() async {
    _token = await _tokenStorage.getToken();
    notifyListeners();
  }
//

  Future<void> loadUsername() async {
    _username = await _tokenStorage.getUsername();
    print(_username);
    print("iiiii");
    notifyListeners();
  }

  // Load refresh token securely
  Future<void> loadRefreshToken() async {
    String? refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      print("Loaded Refresh Token: $refreshToken");
    }
  }

  // Refresh the access token using the refresh token
  Future<void> refreshAccessToken() async {
    if (isTokenExpired()) {
      String? refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken != null) {
        final response = await http.post(
          Uri.parse('http://45.117.153.90:5004/Account/RefreshToken/'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"refreshToken": refreshToken}),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final newToken = responseData['token'];

          await _tokenStorage.storeToken(newToken);
          _token = newToken;
          notifyListeners();
        } else {
          _setErrorMessage("Failed to refresh token");
        }
      }
    }
  }

  // Logout and remove both access and refresh tokens
  Future<void> logout() async {
    await _tokenStorage.removeToken();
    await _tokenStorage.removeRefreshToken();
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
