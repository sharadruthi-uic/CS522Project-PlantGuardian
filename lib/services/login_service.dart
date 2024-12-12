import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String baseUrl = "https://yourapi.com"; // Replace with your API base URL

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final Dio dio = Dio();
    final String endpoint = 'https://plant-api-s16r.onrender.com/api/auth/login'; // Replace with your login endpoint

    try {
      print("Logging in with email: $email and password: $password");

      // Making POST request using Dio
      final response = await dio.post(
        endpoint,
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Save token locally
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
        }

        return data;
      } else {
        print("Failed to login. Status Code: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Failed to login. Please check your credentials.'
        };
      }
    } on DioError catch (e) {
      // Handle Dio errors
      print("Dio error occurred: ${e.response?.data ?? e.message}");
      return {
        'success': false,
        'message': e.response?.data['message'] ??
            'An error occurred while trying to login.'
      };
    } catch (e) {
      // Handle unexpected errors
      print("An unexpected error occurred: $e");
      return {'success': false, 'message': 'An unexpected error occurred: $e'};
    }
  }
}
