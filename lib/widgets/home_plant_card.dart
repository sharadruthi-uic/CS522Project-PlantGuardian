import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String name;
  final String type;
  final String wateringSchedule;
  final String fertilizingSchedule;
  final String sunlightRequirement;
  final String purchaseDate;
  final String reminderTime;
  final String? status; // Add status
  final Color? statusColor; // Add status color

  const PlantCard({
    Key? key,
    required this.name,
    required this.type,
    required this.wateringSchedule,
    required this.fertilizingSchedule,
    required this.sunlightRequirement,
    required this.purchaseDate,
    required this.reminderTime,
    this.status, // Add status
    this.statusColor, // Add status color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_florist,
                size: 40,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            // Plant Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status (optional)
                  if (status != null)
                    Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: statusColor ?? Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          status!,
                          style: TextStyle(fontSize: 14, color: statusColor ?? Colors.grey),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Type
                  Text(
                    "Type: $type",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Watering Schedule
                  Text(
                    "Watering: $wateringSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Fertilizing Schedule
                  Text(
                    "Fertilizing: $fertilizingSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Sunlight Requirement
                  Text(
                    "Sunlight: $sunlightRequirement",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Purchase Date
                  Text(
                    "Purchase Date: $purchaseDate",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Reminder Time
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
