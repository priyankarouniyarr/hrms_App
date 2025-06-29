import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/screen/branch_id.dart';
import 'package:hrms_app/screen/hospitalcode.dart';
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
  //final HosptialCodeStorage _hosptialcode = HosptialCodeStorage();
  final HosptialCodeStorage _hospitalCodeStorage =
      HosptialCodeStorage(); // Initialize storage
  final UsernameStorage _usernameStorage = UsernameStorage();
  final ExpirationtimeStorage _expirationtimeStorage = ExpirationtimeStorage();
  final RefreshTokenStorage _refreshtokenStorage = RefreshTokenStorage();
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get token => _token;
  String? get username => _username;

  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
    // Retrieve stored base URL
  }

  // Store base URL securely
  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    log("Stored Base URL: $baseUrl");
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    _setLoading(true);

    if (username.isEmpty || password.isEmpty) {
      _setErrorMessage("Please enter both username and password");
      _setLoading(false);

      return;
    }

    try {
      final baseUrl = await _getBaseUrl();

      log("baseUrls: $baseUrl");
      log("priyanka");

      if (baseUrl == null) {
        log("Base URL is null");

        _setErrorMessage(
            "Base URL not found. Please enter hospital code agains.");
        _setLoading(false);
        await Future.delayed(Duration(seconds: 5)); // Delay for 2 seconds

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HospitalCodeScreen()),
        );
        clearErrorMessage();
        return;
      }
      // Ensure the base URL is stored (in case it was fetched externally)
      await _storeBaseUrl(baseUrl);
      LoginScreenModel loginModel = LoginScreenModel(
        username: username,
        password: password,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/Account/LoginUser'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(loginModel.toJson()),
      );
      log(response.statusCode.toString());

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
      _setErrorMessage("Failed to login in");

      await Future.delayed(Duration(seconds: 5)); // Delay for 2 seconds

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HospitalCodeScreen()),
      );
      clearErrorMessage();
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
  }

  Future<void> loadToken() async {
    _token = await _tokenStorage.getToken();
  }

  Future<void> loadUsername() async {
    _username = await _usernameStorage.getUsername();
    print(_username);
  }

  // Load refresh token securely
  Future<void> loadRefreshToken() async {
    String? refreshToken = await _refreshtokenStorage.getRefreshToken();
    log("refreshToken1: $refreshToken");
    DateTime? expirationtime = await _expirationtimeStorage.getExpirationtime();
    log("expiration time: $expirationtime");
    _expirationTime = expirationtime;

    log("expirytime loaded :$_expirationTime");
    if (refreshToken != null) {
      log("Loaded Refresh Token: $refreshToken");
    }
  }

  // Refresh the access token using the refresh token
  Future<void> refreshAccessToken(BuildContext context) async {
    if (isTokenExpired()) {
      _setLoading(true);
      String? refreshToken = await _refreshtokenStorage.getRefreshToken();
      print("refreshToken :$refreshToken");

      if (refreshToken != null) {
        try {
          final baseUrl = await _getBaseUrl();
          if (baseUrl == null) {
            _setErrorMessage(
                "Base URL not found. Please enter hospital code again.");
            _setLoading(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HospitalCodeScreen()),
            );
            return;
          }
          // Ensure the base URL is stored
          await _storeBaseUrl(baseUrl);
          final branchId =
              await _secureStorageService.readData('selected_workingbranchId');

          final token = await _secureStorageService.readData('auth_token');
          final fiscalYear =
              await _secureStorageService.readData('selected_fiscal_year');

          if (branchId == null || token == null || fiscalYear == null) {
            throw Exception('No branchId or token found');
          }

          final response = await http.post(
            Uri.parse('$baseUrl/Account/RefreshToken/refresh'),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "workingBranchId": branchId,
              "workingFinancialId": fiscalYear,
            },
            body: json.encode({"RefreshToken": refreshToken}),
          );

          log("refresh token status code: ${response.statusCode}");
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            log(responseData);

            final newToken = responseData['token'];
            log("new token: $newToken");

            final newRefreshToken = responseData['refreshToken'];

            _expirationTime =
                DateTime.parse(responseData['expiration'].toString());

            log("new expiration: $_expirationTime");
            await _tokenStorage.storeToken(newToken);
            await _expirationtimeStorage.storeExpiationTime(_expirationTime!);
            await _refreshtokenStorage.storeRefreshToken(newRefreshToken);
            _token = newToken;
          } else {
            _setErrorMessage(" Error refreshing token: ${response.statusCode}");

            await logout(context);
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
    await _hospitalCodeStorage.removeHospitalCode();
    await _hospitalCodeStorage.removeBaseUrl();
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
