import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_plant_form.dart';

class PlantIdentificationScreen extends StatefulWidget {
  final File imageFile;

  PlantIdentificationScreen({required this.imageFile});

  @override
  _PlantIdentificationScreenState createState() =>
      _PlantIdentificationScreenState();
}

class _PlantIdentificationScreenState extends State<PlantIdentificationScreen> {
  bool _isLoading = false;
  String? _plantFamilyName;
  String? _error;

  @override
  void initState() {
    super.initState();
    _identifyPlant();
  }

  Future<void> _identifyPlant() async {
    setState(() {
      _isLoading = true;
      _plantFamilyName = null;
      _error = null;
    });

    try {
      final Uri url = Uri.parse(
          'https://my-api.plantnet.org/v2/identify/all?include-related-images=false&no-reject=false&nb-results=10&lang=en&api-key=YOUR_API_KEY');
      final request = http.MultipartRequest('POST', url);
      request.files.add(
          await http.MultipartFile.fromPath('images', widget.imageFile.path));
      request.fields['organs'] = 'auto';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        // Extract the plant family scientific name
        if (data['results'] != null && data['results'].isNotEmpty) {
          final firstResult = data['results'][0];
          setState(() {
            _plantFamilyName = firstResult['species']['family']
            ?['scientificName'] ??
                'Orchid'; // Default to "Orchid" if no family name
          });
        } else {
          setState(() {
            _plantFamilyName = 'Orchid'; // Default to "Orchid" if no results
          });
        }
      } else {
        setState(() {
          _plantFamilyName = 'Orchid'; // Default to "Orchid" for non-200 responses
        });
      }
    } catch (e) {
      setState(() {
        _plantFamilyName = 'Orchid'; // Default to "Orchid" on error
        _error = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6F5D6),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                // Display the captured image
                Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(widget.imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Icon(Icons.more_vert, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Plant information container
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6F5D6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "😊 Eureka! We've identified your plant.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isLoading
                              ? 'Identifying plant family...'
                              : (_plantFamilyName ?? 'Unknown Family'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Orchids are plants that belong to the family Orchidaceae, a diverse and widespread group of flowering plants with blooms that are often colorful and fragrant.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: const [
                                Icon(Icons.wb_sunny, color: Colors.orange),
                                SizedBox(height: 8),
                                Text("Sunlight",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("Normal",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                              ],
                            ),
                            Column(
                              children: const [
                                Icon(Icons.water_drop, color: Colors.blue),
                                SizedBox(height: 8),
                                Text("Water",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("333ml",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                              ],
                            ),
                            Column(
                              children: const [
                                Icon(Icons.thermostat, color: Colors.purple),
                                SizedBox(height: 8),
                                Text("Humidity",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("56%",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _plantFamilyName == 'Unknown Family'
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Pops to the previous page
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                : ElevatedButton(
              onPressed: () {
                // Ensure both type and image are available before navigating
                if (_plantFamilyName != null && widget.imageFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPlantForm(),
                      settings: RouteSettings(
                        arguments: {
                          'familyName': _plantFamilyName,
                          'imageFile': widget.imageFile, // Pass the image file
                        },
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Plant type or image is missing.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Add this plant",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
