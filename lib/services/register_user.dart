import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = "https://yourapi.com"; // Replace with your API base URL

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final Uri url = Uri.parse('https://plant-api-s16r.onrender.com/api/auth/register');
    try {
      // Print details for debugging
      print("Registering user with details:");
      print("Name: $name");
      print("Email: $email");
      print("Phone: $phone");
      print("Password: $password");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response: $data"); // Log the response from the server
        return data; // Returns the success or error message
      } else {
        print("Failed to register. Status Code: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Failed to register. Please try again later.'
        };
      }
    } catch (e) {
      print("An error occurred: $e");
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
