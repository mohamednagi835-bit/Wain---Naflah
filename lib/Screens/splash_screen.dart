import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    /// ⛔ AUTH / NAVIGATION LOGIC (COMMENTED FOR NOW)

    /*
    if (AuthService.currentUser == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (AuthService.role == "admin") {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
    */

    /// ✅ UI ONLY MODE → do nothing for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // light clean background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🌿 Artistic Logo Container
            // Container(
            //     width: 120,
            //     height: 120,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       shape: BoxShape.circle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.08),
            //           blurRadius: 25,
            //           spreadRadius: 5,
            //         )
            //       ],
            //     ),
            //     child: const Icon(
            //       Icons.travel_explore,
            //       size: 60,
            //       color: Color(0xFF2E7D32),
            //     ),
            //   ),
            Center(
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.white,
                // 👈 gives breathing space
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// 🇸🇦 App Name
            const Text(
              "استكشف المملكة العربية السعودية",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "Discover Saudi Arabia",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),

            // const SizedBox(height: 8),

            // /// 🌍 Subtitle (EN + AR)
            // const Text(
            //   "Discover Saudi Arabiaاستكشف المملكة العربية السعودية",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey,
            //   ),
            // ),
            const SizedBox(height: 40),

            /// ⏳ Loading Indicator (light style)
            const CircularProgressIndicator(
              color: Color(0xFF2E7D32),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
