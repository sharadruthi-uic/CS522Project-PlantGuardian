import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/fetch_plants_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';

class PlantListScreen extends StatefulWidget {
  @override
  _PlantListScreenState createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  late Future<List<Map<String, dynamic>>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = FetchPlantsService.fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Plants"), // Custom app bar
      backgroundColor: const Color(0xFFEFF6EE),
      bottomNavigationBar: const CustomBottomNavBar(), // Custom bottom nav bar
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            // Handle empty or null products array
            return const Center(
              child: Text(
                "No plants available. Add your first plant!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            );
          }

          final plants = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return PlantCard(
                  name: plant["name"] ?? "Unknown",
                  type: plant["type"] ?? "Type not specified",
                  wateringSchedule: plant["wateringSchedule"] ?? "N/A",
                  fertilizingSchedule: plant["fertilizingSchedule"] ?? "N/A",
                  sunlightRequirement: plant["sunlightRequirement"] ?? "N/A",
                  purchaseDate: plant["purchaseDate"] ?? "N/A",
                  reminderTime: plant["reminderTime"] ?? "N/A",
                  photo: plant['photo'] ?? "",
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String name;
  final String type;
  final String wateringSchedule;
  final String fertilizingSchedule;
  final String sunlightRequirement;
  final String purchaseDate;
  final String reminderTime;
  final String photo; // Base64 string for the plant image

  const PlantCard({
    Key? key,
    required this.name,
    required this.type,
    required this.wateringSchedule,
    required this.fertilizingSchedule,
    required this.sunlightRequirement,
    required this.purchaseDate,
    required this.reminderTime,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget plantImage;
    try {
      if (photo.isNotEmpty) {
        // Decode the base64 string and create an Image widget
        final decodedBytes = base64Decode(photo);
        plantImage = Image.memory(
          decodedBytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else {
        // Display a placeholder if the photo is empty
        plantImage = Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        );
      }
    } catch (e) {
      // Handle decoding errors
      plantImage = Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the decoded image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: plantImage,
            ),
            const SizedBox(width: 16),
            // Display plant details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Type: $type",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Watering: $wateringSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Fertilizing: $fertilizingSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Sunlight: $sunlightRequirement",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Purchase Date: $purchaseDate",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Reminder Time: $reminderTime",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
