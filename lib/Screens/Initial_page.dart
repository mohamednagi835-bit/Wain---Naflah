import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/Home_screen.dart';
import 'package:tourism_app/Screens/login_screen.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(); // logged in
        } else {
          return LoginScreen(); // not logged in
        }
      },
    );
  }
}
