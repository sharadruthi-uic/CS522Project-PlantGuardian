import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchRemindersService {
  static const String _baseUrl = "https://plant-api-s16r.onrender.com/api/user";

  static Future<List<Map<String, dynamic>>> fetchReminders() async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("User is not authenticated. Token not found.");
      }

      // Make the HTTP GET request with the Authorization header
      final response = await http.get(
        Uri.parse("$_baseUrl/allremainders"),
        headers: {
          'Authorization': 'Bearer $token', // Add the token here
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(response.body); // Debugging
        if (data.containsKey("remainders")) {
          return List<Map<String, dynamic>>.from(data["remainders"]);
        }
      } else {
        throw Exception(
          "Failed to fetch reminders. Status code: ${response.statusCode}, Body: ${response.body}",
        );
      }

      return [];
    } catch (error) {
      print(error);
      throw Exception("Failed to fetch reminders: $error");
    }
  }
}
