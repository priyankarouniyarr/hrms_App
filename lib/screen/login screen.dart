import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        backgroundColor: primarySwatch[900],
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Log In",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        primarySwatch,
                        primarySwatch.withOpacity(0.5),
                        primarySwatch.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Username", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                onChanged: (value) {
                  authProvider.clearErrorMessage();
                },
                decoration: InputDecoration(
                  hintText: "Your Username",
                  hintStyle: TextStyle(color: primarySwatch.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: primarySwatch),
                  ),
                ),
                style: TextStyle(color: primarySwatch[900], fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text("Password"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: (value) {
                  authProvider.clearErrorMessage();
                },
                decoration: InputDecoration(
                  hintText: "Your Password",
                  hintStyle: TextStyle(color: primarySwatch.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: primarySwatch),
                  ),
                  suffixIcon: IconButton(
                    color: primarySwatch[900],
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: primarySwatch[900], fontSize: 20),
              ),
              const SizedBox(height: 20),
              // Show error message if available
              if (authProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authProvider.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                    context,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: primarySwatch[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: authProvider.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cardBackgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
