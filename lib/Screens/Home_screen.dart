import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Models/user.dart';
import 'package:tourism_app/Screens/Add_place_screen.dart';
import 'package:tourism_app/Screens/Feed_screen.dart';
import 'package:tourism_app/Screens/Feed_screen.dart';
import 'package:tourism_app/Screens/Initial_page.dart';
import 'package:tourism_app/Screens/Profile_screen.dart';
import 'package:tourism_app/cubits/Feed_screen_cubit/Feed_screen_cubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<int> prevIndecies = [0];
  final ScrollController feedController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blockStatus();
    getUser();
  }

  // Future<void> getCurrrentUser() async {
  //   await getUser();
  // }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screens = [
      FeedScreen(feedController: feedController),
      AddPlaceScreen(),
      AccountScreen(),
    ];
    return Scaffold(
      body: //screens[currentIndex],
      IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          prevIndecies.add(index);
          if (index == 0 && prevIndecies[prevIndecies.length - 2] == 0) {
            feedController.animateTo(
              0,
              duration: const Duration(microseconds: 200),
              curve: Curves.easeInOut,
            );
            prevIndecies = [0];
          }
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
            label: loc.addPlace,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: loc.profile,
          ),
        ],
      ),
    );
  }

  Future<void> getUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) return;

    currentUser = AppuUSer(
      email: doc['email'] ?? '',
      paaword: doc['Password'] ?? '',
      firsrName: doc['First Name'] ?? '',
      lastName: doc['Last Name'] ?? '',
      phoneNumber: doc['Phone Number'] ?? '',
      id: doc.id,
    );
  }

  Future<void> blockStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (!doc.exists) {
      return;
    } else {
      if (doc['isBlocked'] == 'True') {
        await FirebaseAuth.instance.signOut();

        // Navigator.pushAndRemoveUntil(
        //   context,

        //   MaterialPageRoute(builder: (context) => InitialPage()),

        //   (route) => false,
        // );
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    feedController.dispose();
  }
}

// Future<void> getUser() async {
//   final user = FirebaseAuth.instance.currentUser;

//   final email = user?.email;

//   print(email);
//   final query = await FirebaseFirestore.instance
//       .collection('users')
//       .where('email', isEqualTo: email)
//       .limit(1)
//       .get();

//   if (query.docs.isEmpty) return;

//   final doc = query.docs.first.data();
//   currentUser = AppuUSer(
//     email: doc['email'] ?? '',
//     paaword: doc['password'] ?? '',
//     firsrName: doc['First Name'] ?? '',
//     lastName: doc['Last Name'] ?? '',
//     phoneNumber: doc['Phone Number'] ?? '',
//   );
// }
