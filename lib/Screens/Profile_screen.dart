import 'package:flutter/material.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Screens/Change_language.dart';
import 'package:tourism_app/Screens/Edit_options_screen.dart';
import 'package:tourism_app/Screens/Favourite_places.dart';
import 'package:tourism_app/Screens/Feed_screen.dart';
import 'package:tourism_app/Screens/edit_profile_screen.dart';
import 'package:tourism_app/Widgets/Logout_Dialog.dart';
import 'package:tourism_app/Widgets/build_option.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.account,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                loc.manageProfile,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 👤 PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  /// 🧑 Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🏷️ Name
                  Text(
                    '${currentUser.firsrName} ${currentUser.lastName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// 📧 Email
                  Text(
                    currentUser.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 📊 STATS
            // Container(
            //   color: Colors.white,
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       _buildStat("12", loc.places),
            //       _buildStat("45", loc.likes),
            //       _buildStat("8", loc.comments),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 0),

            /// ⚙️ OPTIONS
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  BuildOption(
                    icon: Icons.edit,
                    title: loc.editProfile,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProfileOptionsScreen();
                          },
                        ),
                      );
                    },
                  ),

                  BuildOption(
                    icon: Icons.place,
                    title: loc.myPlaces,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FeedScreen();
                          },
                        ),
                      );
                    },
                  ),

                  // BuildOption(
                  //   icon: Icons.settings,
                  //   title: loc.settings,
                  //   onTap: () {},
                  // ),
                  BuildOption(
                    icon: Icons.language,
                    title: loc.language,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChangeLanguage();
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  BuildOption(
                    icon: Icons.logout,
                    title: loc.logout,
                    color: Colors.red,
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 STAT ITEM
  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

  /// ⚙️ OPTION ITEM

