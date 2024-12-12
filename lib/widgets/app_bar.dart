import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget {
  final String location; // Dynamic location
  final String temperature; // Dynamic temperature
  final String humidity; // Dynamic humidity

  const CustomHomeAppBar({
    Key? key,
    required this.location,
    required this.temperature,
    required this.humidity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF6EE),
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.blue),
              const SizedBox(width: 4),
              Text('23%'),
              const SizedBox(width: 16),
              const Icon(Icons.thermostat, color: Colors.red),
              const SizedBox(width: 4),
              Text('$temperature°C'),
              const SizedBox(width: 16),
              const Icon(Icons.wb_sunny, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
