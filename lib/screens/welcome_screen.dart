import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utlis/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // App Logo and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.eco, size: 40, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  "Plant Guardian",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Illustration Placeholder
            Image.asset(
              'assets/intro.png', // Replace with your SVG file path
              height: 200, // Adjust the height as needed
            ),
            const SizedBox(height: 16),
            // Subtitle
            const Text(
              "Make your life greener!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // "Get Started" Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Get started!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
