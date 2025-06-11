import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/login%20screen.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // Import pin_code_fields
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
      await provider.fetchBaseUrl(enteredCode);

      if (provider.baseUrl.isNotEmpty) {
        // Store the hospital code
        final hosptialcode = HosptialCodeStorage();
        await hosptialcode.storeHospitalCode(enteredCode);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _clearOtpField() {
    setState(() {
      enteredCode = ''; // Reset OTP field
      _pinController.clear();
    });
    _clearErrorMessage(); // Clear any error messages
  }

  void _clearErrorMessage() {
    final provider = Provider.of<HospitalCodeProvider>(context, listen: false);
    provider.clearError();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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

              // PIN Input Field using pin_code_fields
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
              if (hospitalProvider.isLoading)
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
            ],
          ),
        ),
      ),
    );
  }
}
