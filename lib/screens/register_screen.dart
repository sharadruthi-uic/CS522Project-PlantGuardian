import 'package:flutter/material.dart';
import '../utlis/constants.dart';
import '../services/register_user.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await RegisterService.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('message') && response['message'] != null) {
        if (response['message'].toLowerCase().contains("success")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
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
                "Create an Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Name",
                hintText: "Enter your name",
                icon: Icons.person,
                obscureText: false,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                label: "Phone",
                hintText: "Enter your phone number",
                icon: Icons.phone,
                obscureText: false,
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
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
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Confirm Password",
                hintText: "Confirm your password",
                icon: Icons.lock_outline,
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
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
                child: const Text("Register"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already have an account? Login",
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
