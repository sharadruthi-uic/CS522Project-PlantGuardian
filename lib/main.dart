import 'package:flutter/material.dart';
import 'package:plant/screens/plant_identification_screen.dart';
import 'package:plant/screens/remainder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant/screens/add_plant_form.dart';
import 'package:plant/screens/home_screen.dart';
import 'package:plant/screens/login_screen.dart';
import 'package:plant/screens/plant_identify_screen.dart';
import 'package:plant/screens/plant_list_screen.dart';
import 'package:plant/screens/profile_screen.dart';
import 'package:plant/screens/register_screen.dart';
import 'package:plant/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for token in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(initialRoute: token != null ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/plants': (context) => PlantListScreen(),
        '/add-plant': (context) => AddPlantForm(),
        '/identify-plant': (context) => PlantIdentifyScreen(),
        '/remainder-screen': (context) => RemainderScreen(),

        // '/identification-plant': (context) => PlantIdentificationScreen(),

      },
    );
  }
}
