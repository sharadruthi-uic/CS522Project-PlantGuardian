import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/screens/plant_identification_screen.dart';
import 'dart:io';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/fetch_plants_service.dart';
import '../services/fetch_reminders_service.dart';
import '../widgets/alert_title.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _weatherFuture;
  late Future<List<Map<String, dynamic>>> _plantsFuture;
  late Future<List<Map<String, dynamic>>> _remindersFuture;

  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantIdentificationScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
    _plantsFuture = FetchPlantsService.fetchPlants();
    _remindersFuture = FetchRemindersService.fetchReminders();
  }

  Future<Map<String, dynamic>> _fetchWeather() async {
    try {
      final position = await LocationService.getCurrentLocation();
      return await WeatherService.fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      return {
        "location": "Unknown Location",
        "temperature": "N/A",
        "humidity": "N/A",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0); // This will close the app
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF6EE),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _weatherFuture,
          builder: (context, weatherSnapshot) {
            if (weatherSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (weatherSnapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${weatherSnapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!weatherSnapshot.hasData) {
              return const Center(
                child: Text("Unable to fetch weather data."),
              );
            }

            final weather = weatherSnapshot.data!;

            return Column(
              children: [
                CustomHomeAppBar(
                  location: weather["location"],
                  temperature: weather["temperature"].toString(),
                  humidity: weather["humidity"].toString(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Plants',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _plantsFuture,
                            builder: (context, plantsSnapshot) {
                              if (plantsSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (plantsSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "Error: ${plantsSnapshot.error}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              } else if (!plantsSnapshot.hasData || plantsSnapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("No plants available."),
                                );
                              }

                              final plants = plantsSnapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: plants.length,
                                itemBuilder: (context, index) {
                                  final plant = plants[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: HomePlantCard(
                                      name: plant["name"],
                                      type: plant["type"],
                                      healthStatus: plant["healthStatus"], // Example field
                                      photo: plant["photo"], // Pass base64 image string
                                    ),
                                  );
                                },
                              );


                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/add-plant');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New Plant'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _captureImage(context);
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Identify Plant!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _remindersFuture,
                          builder: (context, remindersSnapshot) {
                            if (remindersSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (remindersSnapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${remindersSnapshot.error}",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            } else if (!remindersSnapshot.hasData || remindersSnapshot.data!.isEmpty) {
                              return const Center(
                                child: Text("No reminders available."),
                              );
                            }

                            final reminders = remindersSnapshot.data!;
                            return Expanded( // Ensure it fits in the remaining screen space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Alerts for Today',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, '/remainder-screen');
                                        },
                                        child: const Text(
                                          'View All',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded( // Make the list scrollable
                                    child: ListView.builder(
                                      itemCount: reminders.length,
                                      itemBuilder: (context, index) {
                                        final reminder = reminders[index];
                                        return AlertTile(
                                          title: reminder["title"] ?? "No Title",
                                          subtitle: reminder["body"] ?? "No Details",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}



class HomePlantCard extends StatelessWidget {
  final String? name;
  final String? type;
  final String? healthStatus;
  final String? photo; // Base64-encoded image string

  const HomePlantCard({
    Key? key,
    this.name,
    this.type,
    this.healthStatus,
    this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decode base64 photo string to Image
    Widget plantImage;
    if (photo != null && photo!.isNotEmpty) {
      try {
        final decodedBytes = base64Decode(photo!);
        plantImage = Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        plantImage = Container(color: Colors.grey); // Placeholder for invalid image
      }
    } else {
      plantImage = Container(color: Colors.grey); // Placeholder for missing image
    }

    return AspectRatio(
      aspectRatio: 3 / 4, // Adjust the aspect ratio to match the desired design
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded corners
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(child: plantImage),

            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Text Overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Plant Name and Type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        type ?? "Unknown Type",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Health Status
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(
                  //     healthStatus ?? "Healthy",
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
