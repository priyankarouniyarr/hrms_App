import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/login%20screen.dart';
import 'package:hrms_app/providers/hosptial_code_provider.dart';

class HospitalCodeScreen extends StatefulWidget {
  @override
  _HospitalCodeScreenState createState() => _HospitalCodeScreenState();
}

class _HospitalCodeScreenState extends State<HospitalCodeScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  String enteredCode = ''; // Store entered OTP code

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

  void _clearOtpField() {
    setState(() {
      enteredCode = ''; // Reset OTP field

      for (var i = 0; i < controllers.length; i++) {
        controllers[i].clear();
      }
    });

    FocusScope.of(context).requestFocus(focusNodes[0]);
    _clearErrorMessage(); // Clear any error messages
  }

  //
  void _clearErrorMessage() {
    final provider = Provider.of<HospitalCodeProvider>(context, listen: false);
    provider.clearError();
  }

  // Function to handle text input and move focus automatically
  void _onChanged(String value, int index) {
    setState(() {
      enteredCode = controllers.map((controller) => controller.text).join();
    });

    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
  }

  void _onBackspace(int index) {
    if (controllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 56,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      cursorColor: primarySwatch[900],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) => _onChanged(value, index),
                      onEditingComplete: () {
                        if (index < 5 && controllers[index].text.isNotEmpty) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 1]);
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '', // Hide the length counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: lightColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: primarySwatch,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
