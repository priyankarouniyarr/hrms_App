import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/screen/branch_id.dart';
import 'package:hrms_app/screen/hospitalcode.dart';
import 'package:hrms_app/models/login_screen_models/loginscreen_models.dart';
import 'package:hrms_app/storage/token_storage.dart'; // Import the TokenStorage

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _token;
  String? _username;
  DateTime? _expirationTime;

  final TokenStorage _tokenStorage = TokenStorage();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get token => _token;
  String? get username => _username;

  Future<void> login(
      String username, String password, BuildContext context) async {
    _setLoading(true);

    if (username.isEmpty || password.isEmpty) {
      _setErrorMessage("Please enter both username and password");
      _setLoading(false);

      return;
    }

    try {
      LoginScreenModel loginModel = LoginScreenModel(
        username: username,
        password: password,
      );

      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/Account/LoginUser'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final refreshToken = responseData['refreshToken'];
        _expirationTime = DateTime.parse(responseData['expiration'].toString());
        // _expirationTime = DateTime.now().add(const Duration(minutes: 1));
        print("new expiration: $_expirationTime");

        _username = username;

        await _tokenStorage.storeToken(token);
        await _tokenStorage.storeUsername(username);
        await _tokenStorage.storeRefreshToken(refreshToken);
        await _tokenStorage.storeExpiationTime(_expirationTime!);

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
      print("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  bool isTokenExpired() {
    print(_expirationTime);
    if (_expirationTime == null) return true;

    final currentTime = DateTime.now();
    print(currentTime);

    return currentTime.isAfter(_expirationTime!);
  }

  Future<void> loadToken() async {
    _token = await _tokenStorage.getToken();
  }
//

  Future<void> loadUsername() async {
    _username = await _tokenStorage.getUsername();
  }

  // Load refresh token securely
  Future<void> loadRefreshToken() async {
    String? refreshToken = await _tokenStorage.getRefreshToken();
    print(":refreshToken");
    print(refreshToken);

    DateTime? expirationtime = await _tokenStorage.getExpirationtime();
    _expirationTime = expirationtime;
    print("expirytime loaded :$expirationtime");
    if (refreshToken != null) {
      print("Loaded Refresh Token: $refreshToken");
    }
  }

  // Refresh the access token using the refresh token
  Future<void> refreshAccessToken(BuildContext context) async {
    if (isTokenExpired()) {
      String? refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken != null) {
        final response = await http.post(
          Uri.parse('http://45.117.153.90:5004/Account/RefreshToken/refresh'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"RefreshToken": refreshToken}),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          final newToken = responseData['token'];
          final newRefreshToken = responseData['refreshToken'];

          _expirationTime =
              DateTime.parse(responseData['expiration'].toString());
          print("newexpiration:$_expirationTime");
          // _expirationTime = DateTime.now().add(const Duration(seconds: 30));
          print("new expiration: $_expirationTime");
          await _tokenStorage.storeToken(newToken);
          await _tokenStorage.storeExpiationTime(_expirationTime!);
          await _tokenStorage.storeRefreshToken(newRefreshToken);
          _token = newToken;
          print("brek2");
          print("Refresh Token: $newRefreshToken");
        } else {
          _setErrorMessage(" Error refreshing token: ${response.statusCode}");

          // Clear tokens and navigate to login screen if token refresh fails
          // await logout();

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HospitalCodeScreen()),
          // );

          print(
              "Error refreshing token: ${response.statusCode} ${response.body}");
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
