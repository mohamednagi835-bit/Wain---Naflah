import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/Screens/Initial_page.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
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
                  const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  ///  MESSAGE
                  const Text(
                    "Are you sure you want to log out of your account?",
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
                          child: const Text(
                            "Cancel",
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
                                  "Logout",
                                  style: TextStyle(color: Colors.white),
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
