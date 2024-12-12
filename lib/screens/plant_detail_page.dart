import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plantDetails;
  final String plantImagePath;

  PlantDetailPage({required this.plantDetails, required this.plantImagePath});

  @override
  Widget build(BuildContext context) {
    final commonNames = plantDetails['species']['commonNames'] as List<dynamic>? ?? [];
    final genus = plantDetails['species']['genus']['scientificNameWithoutAuthor'];
    final family = plantDetails['species']['family']['scientificNameWithoutAuthor'];
    final scientificName = plantDetails['species']['scientificName'];
    final plantName = commonNames.isNotEmpty ? commonNames.join(', ') : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(plantName),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  plantImagePath,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),

              // Plant Information
              Text(
                plantName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                scientificName ?? 'Scientific name not available',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),

              Text(
                'Genus: $genus\nFamily: $family',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Simulated environmental conditions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.wb_sunny_outlined, color: Colors.orange, size: 30),
                      SizedBox(height: 4),
                      Text('Sunlight\nNormal', textAlign: TextAlign.center),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.water_drop_outlined, color: Colors.blue, size: 30),
                      SizedBox(height: 4),
                      Text('Water\n333ml', textAlign: TextAlign.center),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.thermostat_outlined, color: Colors.red, size: 30),
                      SizedBox(height: 4),
                      Text('Humidity\n56%', textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  // Logic for adding plant can be added here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plant added to your collection!')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add this plant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
