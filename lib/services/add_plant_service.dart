import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

Future<File> resizeImage(File imageFile) async {
  final originalImage = img.decodeImage(await imageFile.readAsBytes());
  if (originalImage == null) {
    throw Exception('Failed to decode image.');
  }

  // Resize the image to a maximum width/height of 1024px (or as needed)
  final resizedImage = img.copyResize(originalImage, width: 1024);

  // Save the resized image back to a temporary file
  final tempDir = Directory.systemTemp;
  final resizedFile = File('${tempDir.path}/resized_image.jpg')
    ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85)); // Adjust quality if needed

  return resizedFile;
}
//
// class AddPlantService {
//   static const String baseUrl = "https://plant-api-s16r.onrender.com/api";
//
//   static Future<Map<String, dynamic>> addPlant({
//     required String name,
//     required String type,
//     required String wateringSchedule,
//     required String fertilizingSchedule,
//     required String sunlightRequirement,
//     required String specialCare,
//     required String purchaseDate,
//     required String reminderTime,
//     required File photo, // Send photo as file
//   }) async {
//     final Uri url = Uri.parse('$baseUrl/plants/add');
//
//     try {
//       // Resize the photo before sending
//       final resizedPhoto = await resizeImage(photo);
//
//       // Get token from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       if (token == null) {
//         return {'success': false, 'message': 'User is not authenticated.'};
//       }
//
//       // Prepare multipart request
//       final request = http.MultipartRequest('POST', url)
//         ..headers['Authorization'] = 'Bearer $token'
//         ..fields['name'] = name
//         ..fields['type'] = type
//         ..fields['wateringSchedule'] = wateringSchedule
//         ..fields['fertilizingSchedule'] = fertilizingSchedule
//         ..fields['sunlightRequirement'] = sunlightRequirement
//         ..fields['specialCare'] = specialCare
//         ..fields['purchaseDate'] = purchaseDate
//         ..fields['reminderTime'] = reminderTime;
//
//       // Attach the resized photo as multipart form-data
//       request.files.add(await http.MultipartFile.fromPath('photo', resizedPhoto.path));
//
//       // Send the request
//       final response = await request.send();
//
//       // Parse the response
//       final responseData = await http.Response.fromStream(response);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(responseData.body);
//         return {'success': true, 'message': data['message'], 'plantId': data['plantId']};
//       } else {
//         final errorData = jsonDecode(responseData.body);
//         return {'success': false, 'message': errorData['error'] ?? 'Failed to add plant.'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'An error occurred: $e'};
//     }
//   }
// }


class AddPlantService {
  static const String baseUrl = "https://plant-api-s16r.onrender.com/api";

  static String getWaterRecommendation(String type) {
    switch (type.toLowerCase()) {
      case 'orchid':
        return "Water your Phalaenopsis orchid once a week, ensuring the potting medium dries completely in between waterings.";
      case 'succulent':
        return "Water your succulent every 2 weeks, ensuring the soil dries out completely before the next watering.";
      case 'fern':
        return "Water your fern twice a week, keeping the soil consistently moist but not waterlogged.";
      case 'pothos':
        return "Water your pothos every 1-2 weeks, letting the topsoil dry out between waterings.";
      case 'snake plant':
        return "Water your snake plant every 3 weeks, ensuring the soil is completely dry between waterings.";
      case 'monstera':
        return "Water your monstera every 1-2 weeks, ensuring the soil is dry 1-2 inches below the surface before rewatering.";
      case 'peace lily':
        return "Water your peace lily once a week or when the topsoil feels dry.";
      case 'aloe vera':
        return "Water your aloe vera every 3 weeks, allowing the soil to dry out completely between waterings.";
      case 'spider plant':
        return "Water your spider plant once a week, keeping the soil lightly moist but not soggy.";
      case 'cactus':
        return "Water your cactus once every 3-4 weeks, ensuring the soil dries out completely between waterings.";
      default:
        return "Water your plant as needed, depending on its specific requirements.";
    }
  }

  static String getFertilizerRecommendation(String type) {
    switch (type.toLowerCase()) {
      case 'orchid':
        return "Feed your orchid every 2 weeks during its growing season using a balanced orchid fertilizer.";
      case 'succulent':
        return "Fertilize your succulent monthly with a balanced liquid fertilizer diluted to half strength.";
      case 'fern':
        return "Fertilize your fern every month with a diluted liquid fertilizer for lush growth.";
      case 'pothos':
        return "Feed your pothos every 4 weeks with a general-purpose houseplant fertilizer.";
      case 'snake plant':
        return "Fertilize your snake plant every 2 months with a cactus-friendly fertilizer during spring and summer.";
      case 'monstera':
        return "Fertilize your monstera monthly with a balanced liquid fertilizer during the growing season.";
      case 'peace lily':
        return "Fertilize your peace lily every 6 weeks with a houseplant fertilizer.";
      case 'aloe vera':
        return "Fertilize your aloe vera every 2-3 months with a succulent-specific fertilizer.";
      case 'spider plant':
        return "Fertilize your spider plant monthly during spring and summer with a general-purpose fertilizer.";
      case 'cactus':
        return "Fertilize your cactus every 2 months with a cactus-specific fertilizer during its active growth phase.";
      default:
        return "Fertilize your plant as recommended for its type.";
    }
  }


  static Future<Map<String, dynamic>> addPlant({
    required String name,
    required String type,
    required String wateringSchedule,
    required String fertilizingSchedule,
    required String sunlightRequirement,
    required String specialCare,
    required String purchaseDate,
    required String reminderTime,
    required File photo,
  }) async {
    final Uri url = Uri.parse('$baseUrl/plants/add');

    try {
      // Resize the photo before sending
      final resizedPhoto = await resizeImage(photo);

      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        return {'success': false, 'message': 'User is not authenticated.'};
      }

      // Prepare multipart request
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['type'] = type
        ..fields['wateringSchedule'] = wateringSchedule
        ..fields['fertilizingSchedule'] = fertilizingSchedule
        ..fields['sunlightRequirement'] = sunlightRequirement
        ..fields['specialCare'] = specialCare
        ..fields['purchaseDate'] = purchaseDate
        ..fields['reminderTime'] = reminderTime;

      // Attach the resized photo as multipart form-data
      request.files.add(await http.MultipartFile.fromPath('photo', resizedPhoto.path));

      // Send the request
      final response = await request.send();

      // Parse the response
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        return {'success': true, 'message': data['message'], 'plantId': data['plantId']};
      } else {
        final errorData = jsonDecode(responseData.body);
        return {'success': false, 'message': errorData['error'] ?? 'Failed to add plant.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
