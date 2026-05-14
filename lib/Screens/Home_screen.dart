import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Models/user.dart';
import 'package:tourism_app/Screens/Feed_screen.dart';
import 'package:tourism_app/Screens/Map_screen.dart';
import 'package:tourism_app/Screens/Profile_screen.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    await getCurrrentUser();
  }

  Future<void> getCurrrentUser() async {
    await getUser();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final screens = [FeedScreen(), MapScreen(), AccountScreen()];

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        selectedItemColor: const Color(0xFF2E7D32),

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            // SizedBox(
            //   width: 24,
            //   height: 24,
            //   child: Image.asset('assets/images/map.png'),
            // ),
            label: loc.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: loc.profile,
          ),
        ],
      ),
    );
  }

  Widget mapColor() {
    if (currentIndex == 1) {
      return Image.asset(
        'assets/images/map.png',
        color: const Color(0xFF2E7D32),
      );
    } else {
      return Image.asset('assets/images/map.png');
    }
  }
}

Future<void> getUser() async {
  final user = FirebaseAuth.instance.currentUser;

  final email = user?.email;

  print(email);
  final query = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (query.docs.isEmpty) return;

  final doc = query.docs.first.data();
  currentUser = AppuUSer(
    email: doc['email'] ?? '',
    paaword: doc['password'] ?? '',
    firsrName: doc['First Name'] ?? '',
    lastName: doc['Last Name'] ?? '',
    phoneNumber: doc['Phone Number'] ?? '',
  );
}
