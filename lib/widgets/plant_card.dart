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
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Icon Section
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              color: Colors.green.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.local_florist,
              size: 60,
              color: Colors.green,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Name and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (status != null)
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: statusColor ?? Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status!,
                              style: TextStyle(
                                fontSize: 12,
                                color: statusColor ?? Colors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Plant Type
                  Text(
                    "Type: $type",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Watering Schedule
                  Text(
                    "Watering: $wateringSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Fertilizing Schedule
                  Text(
                    "Fertilizing: $fertilizingSchedule",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Sunlight Requirement
                  Text(
                    "Sunlight: $sunlightRequirement",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Purchase Date and Reminder
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Purchase: $purchaseDate",
                          style: const TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ),
                      Text(
                        "Reminder: $reminderTime",
                        style: const TextStyle(fontSize: 12, color: Colors.black38),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
