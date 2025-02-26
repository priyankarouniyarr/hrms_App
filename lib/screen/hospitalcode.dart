import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/login%20screen.dart';
import 'package:hrms_app/providers/hosptial_code_provider.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class HospitalCodeScreen extends StatefulWidget {
  @override
  _HospitalCodeScreenState createState() => _HospitalCodeScreenState();
}

class _HospitalCodeScreenState extends State<HospitalCodeScreen> {
  String enteredCode = ''; // Store entered OTP code

  // Function to validate and submit the entered OTP
  void _validateAndSubmit() async {
    if (enteredCode.length == 6) {
      final provider =
          Provider.of<HospitalCodeProvider>(context, listen: false);

      await provider.fetchBaseUrl(enteredCode);
      if (provider.baseUrl.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  // Function to clear OTP field
  void _clearOtpField() {
    setState(() {
      enteredCode = ''; // Reset OTP field
    });
  }

  // Function to clear any error messages
  void _clearErrorMessage() {
    final provider = Provider.of<HospitalCodeProvider>(context, listen: false);
    provider.clearError(); // Method to clear error message
  }

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = context.watch<HospitalCodeProvider>();

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

              // OTP Input Field
              OtpTextField(
                fillColor: cardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                focusedBorderColor: primarySwatch,
                enabledBorderColor: lightColor,
                filled: true,
                numberOfFields: 6,
                showFieldAsBox: true,
                keyboardType: TextInputType.number,
                fieldWidth: 50,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                onCodeChanged: (code) {
                  setState(() {
                    enteredCode = code; // Update entered OTP code
                  });
                  _clearErrorMessage(); // Clear error message
                },
                onSubmit: (code) {
                  setState(() {
                    enteredCode = code; // Update entered OTP code
                  });
                },
              ),
              SizedBox(height: 20),
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
                        onPressed: enteredCode.length == 6
                            ? _validateAndSubmit
                            : null, // Only enabled when 6 digits are entered
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
                            _clearOtpField, // Clear OTP when Cancel is pressed
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
                ],
              ),
              const SizedBox(height: 20),
              if (hospitalProvider.isLoading)
                const Center(child: CircularProgressIndicator()),

              if (hospitalProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hospitalProvider.errorMessage,
                    style: const TextStyle(fontSize: 16, color: accentColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
