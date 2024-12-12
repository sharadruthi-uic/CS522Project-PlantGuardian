import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_florist),
            color: Colors.green, // Highlighted for current tab
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/plants');
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.black,
            onPressed: () {
              // Navigate to Favorites
              Navigator.pushReplacementNamed(context, '/remainder-screen');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
