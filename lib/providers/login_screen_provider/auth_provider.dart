import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/screen/branch_id.dart';
import 'package:hrms_app/screen/hospitalcode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/token_storage.dart';
import 'package:hrms_app/storage/username_storage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/storage/refresh_token_storage.dart';
import 'package:hrms_app/storage/expirationtime_storage.dart';
import 'package:hrms_app/storage/branchid_fiscalyear_storage.dart';
import 'package:hrms_app/models/login_screen_models/loginscreen_models.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _token;
  String? _username;
  DateTime? _expirationTime;
  final SecureStorageService _secureStorageService = SecureStorageService();
  final TokenStorage _tokenStorage = TokenStorage();
  final BranchidFiscalyearStorage _branchidFiscalyearStorage =
      BranchidFiscalyearStorage();
  final HosptialCodeStorage _hosptialcode = HosptialCodeStorage();
  final UsernameStorage _usernameStorage = UsernameStorage();
  final ExpirationtimeStorage _expirationtimeStorage = ExpirationtimeStorage();
  final RefreshTokenStorage _refreshtokenStorage = RefreshTokenStorage();
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
        Uri.parse('${dotenv.env['base_url']}Account/LoginUser'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        final refreshToken = responseData['refreshToken'];

        _expirationTime = DateTime.parse(responseData['expiration'].toString());

        _username = username;

        await _tokenStorage.storeToken(token);
        await _usernameStorage.storeUsername(username);

        await _refreshtokenStorage.storeRefreshToken(refreshToken);
        await _expirationtimeStorage.storeExpiationTime(_expirationTime!);

        _token = token;
        print(" 1st token: $_token");
        notifyListeners();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SelectBranchScreen()),
            (route) => false);
      } else {
        _setErrorMessage("Invalid username or password");
      }
    } catch (e) {
      _setErrorMessage("Connection failed");
      print("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

//token checking
  bool isTokenExpired() {
    print("expiration time: $_expirationTime");
    if (_expirationTime == null) return true;
    final currentTime = DateTime.now();
    print("current time: $currentTime");
    return currentTime.isAfter(_expirationTime!);
    // final time =
    //     DateTime.now().isBefore(_expirationTime!.add(Duration(seconds: 20)));
    // print("time: $time");
    // return time;
  }

  Future<void> loadToken() async {
    _token = await _tokenStorage.getToken();
  }

  Future<void> loadUsername() async {
    _username = await _usernameStorage.getUsername();
  }

  // Load refresh token securely
  Future<void> loadRefreshToken() async {
    String? refreshToken = await _refreshtokenStorage.getRefreshToken();
    print("refreshToken1: $refreshToken");
    DateTime? expirationtime = await _expirationtimeStorage.getExpirationtime();
    print("expiration time: $expirationtime");
    _expirationTime = expirationtime;

    print("expirytime loaded :$_expirationTime");
    if (refreshToken != null) {
      print("Loaded Refresh Token: $refreshToken");
    }
  }

  // Refresh the access token using the refresh token
  Future<void> refreshAccessToken(
    BuildContext context,
  ) async {
    if (isTokenExpired()) {
      _setLoading(true);
      String? refreshToken = await _refreshtokenStorage.getRefreshToken();

      print("refreshToken :$refreshToken");

      if (refreshToken != null) {
        try {
          final branchId =
              await _secureStorageService.readData('selected_workingbranchId');

          final token = await _secureStorageService.readData('auth_token');
          final fiscalYear =
              await _secureStorageService.readData('selected_fiscal_year');

          if (branchId == null || token == null || fiscalYear == null) {
            throw Exception('No branchId or token found');
          }

          final response = await http.post(
            Uri.parse('${dotenv.env['base_url']}Account/RefreshToken/refresh'),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "workingBranchId": branchId,
              "workingFinancialId": fiscalYear,
            },
            body: json.encode({"RefreshToken": refreshToken}),
          );

          print("refresh token status code: ${response.statusCode}");
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            print(responseData);

            final newToken = responseData['token'];
            print("new token: $newToken");

            final newRefreshToken = responseData['refreshToken'];

            _expirationTime =
                DateTime.parse(responseData['expiration'].toString());

            print("new expiration: $_expirationTime");
            await _tokenStorage.storeToken(newToken);
            await _expirationtimeStorage.storeExpiationTime(_expirationTime!);
            await _refreshtokenStorage.storeRefreshToken(newRefreshToken);
            _token = newToken;
          } else {
            _setErrorMessage(" Error refreshing token: ${response.statusCode}");

            await logout(
              context,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HospitalCodeScreen()),
            );
          }
        } catch (e) {
          print(
              "Error refreshing token: $e"); // Handle any errors that occur during the refresh
        }
      }
    }
  }

// Logout and remove both access and refresh tokens
  Future<void> logout(BuildContext context) async {
    await _tokenStorage.removeToken();
    await _usernameStorage.removeUsername();
    await _refreshtokenStorage.removeRefreshToken();
    await _expirationtimeStorage.removeExpirationTime();
    await _branchidFiscalyearStorage.removeBranchIdAndFiscalYearId();
    await _branchidFiscalyearStorage.removeBranchId();
    await _hosptialcode.removeHospitalCode();
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
