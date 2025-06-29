import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/login%20screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/providers/notifications/notification_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider/hosptial_code_provider.dart';

class HospitalCodeScreen extends StatefulWidget {
  @override
  _HospitalCodeScreenState createState() => _HospitalCodeScreenState();
}

class _HospitalCodeScreenState extends State<HospitalCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  String enteredCode = '';

  void _validateAndSubmit() async {
    if (enteredCode.length == 6) {
      final provider =
          Provider.of<HospitalCodeProvider>(context, listen: false);
      final fcmNotificationProvider =
          Provider.of<FcmnotificationProvider>(context, listen: false);

      // Clear any previous FCM error messages
      fcmNotificationProvider.clearError();

      // Fetch base URL for the hospital code
      await provider.fetchBaseUrl(enteredCode);

      if (provider.baseUrl.isNotEmpty) {
        final hosptialcode = HosptialCodeStorage();
        await hosptialcode.storeHospitalCode(enteredCode);

        // Get FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        log("code is $enteredCode");

        log("FCM Tokens in Hospital Code Screen: $fcmToken");

        bool fcmSuccess = false;
        if (fcmToken != null) {
          // Call sendFcmDeviceTokenPostAnonymous and check result
          await fcmNotificationProvider.sendFcmDeviceTokenPostAnonymous(
            fcmToken,
            enteredCode,
          );
          // Check if the FCM token was sent successfully (no error message)
          fcmSuccess = fcmNotificationProvider.errorMessage.isEmpty;
          log("FCM Token submission status: $fcmSuccess");
        } else {
          print("FCM Token is null");
          fcmNotificationProvider.setErrorMessage("FCM token unavailable.");
        }

        if (!mounted) return;

        // Navigate to LoginScreen only if FCM token submission was successful or no FCM token
        if (fcmSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        }
      }
    }
  }

  void _clearOtpField() {
    setState(() {
      enteredCode = '';
      _pinController.clear();
    });
    _clearErrorMessage();
  }

  void _clearErrorMessage() {
    final provider = Provider.of<HospitalCodeProvider>(context, listen: false);
    provider.clearError();
    final fcmProvider =
        Provider.of<FcmnotificationProvider>(context, listen: false);
    fcmProvider.clearError();
  }

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = context.watch<HospitalCodeProvider>();
    final fcmNotificationProvider = context.watch<FcmnotificationProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        backgroundColor: primarySwatch[900],
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter Hospital Code",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This is a unique 6-digit code for your hospital. Contact your IT department if you don't have the code.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _pinController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autoFocus: true,
                cursorColor: primarySwatch[900],
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 56,
                  fieldWidth: 56,
                  activeColor: primarySwatch[900],
                  inactiveColor: lightColor,
                  selectedColor: primarySwatch[900],
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() {
                    enteredCode = value;
                  });
                },
                onCompleted: (value) {
                  _validateAndSubmit();
                },
                onTap: _clearErrorMessage,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarySwatch[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _clearOtpField,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarySwatch[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            enteredCode.length == 6 ? _validateAndSubmit : null,
                        child: const Text(
                          "Continue Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (hospitalProvider.isLoading ||
                  fcmNotificationProvider.isLoading)
                const Center(child: CircularProgressIndicator()),
              if (hospitalProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        hospitalProvider.errorMessage,
                        style:
                            const TextStyle(fontSize: 16, color: accentColor),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              if (fcmNotificationProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        fcmNotificationProvider.errorMessage,
                        style:
                            const TextStyle(fontSize: 16, color: accentColor),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
