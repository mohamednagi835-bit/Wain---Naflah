import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/Screens/Initial_page.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final loc = AppLocalizations.of(context)!;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ICON
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ///  TITLE
                  Text(
                    loc.logout,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  ///  MESSAGE
                  Text(
                    loc.confirmLogout,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),

                  const SizedBox(height: 20),

                  // BUTTONS
                  Row(
                    children: [
                      // CANCEL
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loc.cancel,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // LOGOUT
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            isLoading = true;
                            setState(() {});
                            await Future.delayed(Duration(seconds: 1));

                            await FirebaseAuth.instance.signOut();
                            isLoading = false;
                            setState(() {});
                            if (!context.mounted) return;
                            Navigator.pop(context);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InitialPage(),
                              ),
                              (route) => false,
                            );

                            /// Navigate to initial screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  loc.logout,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
