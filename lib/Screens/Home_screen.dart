import 'package:flutter/material.dart';
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
