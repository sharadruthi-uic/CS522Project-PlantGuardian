import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchPlantsService {
  static const String baseUrl = "https://plant-api-s16r.onrender.com/api";

  static Future<List<Map<String, dynamic>>> fetchPlants() async {
    final Uri url = Uri.parse('$baseUrl/plants');

    try {
      // Get token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('User is not authenticated.');
      }

      // Make API Request
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse Products
        final products = (data['products'] as List).map((product) {
          final purchaseDate = product['purchaseDate'] != null &&
              product['purchaseDate']['_seconds'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
            product['purchaseDate']['_seconds'] * 1000,
          ).toLocal()
              : null;

          return {
            'id': product['id'] ?? 'Unknown',
            'name': product['name'] ?? 'Unknown',
            'type': product['type'] ?? 'Unknown',
            'wateringSchedule': product['wateringSchedule'] ?? 'N/A',
            'fertilizingSchedule': product['fertilizingSchedule'] ?? 'N/A',
            'sunlightRequirement': product['sunlightRequirement'] ?? 'N/A',
            'specialCare': product['specialCare'] ?? 'N/A',
            'photo': product['photo'] ?? '', // Include the base64 image string
            'purchaseDate': purchaseDate != null
                ? "${purchaseDate.day}-${purchaseDate.month}-${purchaseDate.year}"
                : 'N/A',
            'reminderTime': product['reminderTime'] ?? 'N/A',
          };
        }).toList();

        return products;
      } else {
        throw Exception('Failed to fetch plants. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
