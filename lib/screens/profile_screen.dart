import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utlis/constants.dart';
import '../widgets/custom_bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> profileData = {
    'name': 'Loading...',
    'email': 'Loading...',
    'phone': 'Loading...',
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails();
  }


  Future<void> _fetchProfileDetails() async {
    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        // Token not found, navigate to login
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // API call to fetch profile details
      final response = await http.get(
        Uri.parse('https://plant-api-s16r.onrender.com/api/user/details'), // Replace with your profile API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['message'] == 'User details fetched successfully.' && data['user'] != null) {
          final user = data['user'];
          setState(() {
            profileData = {
              'name': user['userId'] ?? 'N/A', // Replace 'userId' with a proper 'name' field if available
              'email': user['email'] ?? 'N/A',
              'phone': user['phone'] ?? 'N/A', // No phone in response, so default to 'N/A'
            };
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        // Handle invalid token or error
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile details: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      // Handle network or JSON errors
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(),
      body: Stack(
        children: [
          // Background Design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          // Profile Content
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 100), // Space for the background curve
                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/dp.jpg'), // Replace with your avatar image path
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 48),
                // Name
                Text(
                  profileData['name']!,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Email
                Text(
                  profileData['email']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                // Phone
                Text(
                  profileData['phone']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                // Details Section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileDetailRow(
                          icon: Icons.person_outline,
                          label: "Name",
                          value: profileData['name']!,
                        ),
                        const Divider(),
                        ProfileDetailRow(
                          icon: Icons.email_outlined,
                          label: "Email",
                          value: profileData['email']!,
                        ),
                        const Divider(),
                        ProfileDetailRow(
                          icon: Icons.phone_outlined,
                          label: "Phone",
                          value: profileData['phone']!,
                        ),
                        const Spacer(),
                        // Full-width Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _logout,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: const Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 28),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
