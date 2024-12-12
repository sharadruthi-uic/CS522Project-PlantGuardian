import 'package:flutter/material.dart';
import '../utlis/constants.dart';
import '../widgets/custom_text_field.dart';
import '../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await LoginService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('message') && response['message'] != null) {
        if (response['message'].toLowerCase().contains("success")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          Navigator.pushReplacementNamed(context, '/home'); // Redirect to home screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Email",
                hintText: "Enter your email",
                icon: Icons.email,
                obscureText: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Password",
                hintText: "Enter your password",
                icon: Icons.lock,
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 64,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Login"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
