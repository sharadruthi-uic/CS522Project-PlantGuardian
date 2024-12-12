import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "f3e899109524bedd76a81518ff3e2ad2"; // Replace with your OpenWeatherMap API key
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  static Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        "$baseUrl?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey");

    print("Weather API URL: $url");

    try {
      final response = await http.get(url);

      print("Weather API Response: ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "temperature": data["main"]["temp"].toString(),
          "location": data["name"]
        };
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in WeatherService: $e");
      return {
        "temperature": "N/A",
        "location": "Error fetching weather"
      };
    }
  }
}
