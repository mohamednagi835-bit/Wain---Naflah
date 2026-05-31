import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/Admin_dash_board.dart';
import 'package:tourism_app/Screens/Home_screen.dart';
import 'package:tourism_app/Screens/login_screen.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  Future<bool> isAdmin() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final role = doc['role'];
    if (role == 'Admin') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: isAdmin(),
            builder: (context, adminSnapshot) {
              if (!adminSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (adminSnapshot.data == true) {
                return AdminDashboard();
              } else {
                return HomeScreen();
              }
            },
          );
        } else {
          return LoginScreen(); // not logged in
        }
      },
    );
  }
}
