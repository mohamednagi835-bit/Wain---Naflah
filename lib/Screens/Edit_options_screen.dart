import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/Change_password_screen.dart';
import 'package:tourism_app/Screens/Edit_user_screen.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class EditProfileOptionsScreen extends StatelessWidget {
  const EditProfileOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          loc.editProfile,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            Text(
              loc.accountSettings,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              loc.manageYourAccountInformationSecurely,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),

            const SizedBox(height: 40),

            /// USERNAME CARD
            settingsCard(
              context: context,
              icon: Icons.person_outline,
              title: loc.editUsername,
              subtitle: loc.changeYourFirstAndLastName,
              color: Colors.blue,

              onTap: () {
                /// navigate to edit username screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditUsernameScreen();
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// PASSWORD CARD
            settingsCard(
              context: context,
              icon: Icons.lock_outline,
              title: loc.editPassword,
              subtitle: loc.updateYourAccountPassword,
              color: Colors.green,

              onTap: () {
                /// navigate to edit password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChangePasswordScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: 18),

            /// TEXTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
