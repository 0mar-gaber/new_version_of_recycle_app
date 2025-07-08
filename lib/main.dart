import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/Authuntication/Profile_page.dart';
import 'package:new_version_of_recycle_app/services/getApiService.dart';

import 'Authuntication/Login_page.dart';
import 'Splash_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
      primaryColor: const Color(0xFF1D8560), // Change this as needed
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF1D8560),
        unselectedItemColor: Colors.grey,
      ),
    ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Set SplashScreen as the home screen
    );
  }
}
class CheckLogin extends StatelessWidget {
  final ApiService _apiService = ApiService();

  CheckLogin({super.key});

  @override
    Widget build(BuildContext context) {
      return FutureBuilder<bool>(
        future: _apiService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.pushReplacementNamed(context, '/home'),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.pushReplacementNamed(context, '/login'),
              );
            }
            return Container(); // Empty container while navigating
          }
        },
      );
    }
  }