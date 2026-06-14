import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/Initial_page.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  bool isLoading = false;

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
          loc.editUsername,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            /// HEADER
            Text(
              loc.updateYourName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              loc.makeSureYourInformationIsAccurate,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),

            const SizedBox(height: 40),

            /// FIRST NAME
            customTextField(
              controller: firstNameController,
              label: '${loc.enter} ${loc.firstName}',
              // icon: Icons.person_outline,
            ),

            const SizedBox(height: 22),

            /// LAST NAME
            customTextField(
              controller: lastNameController,
              label: '${loc.enter} ${loc.lastName}',
              //  icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 40),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  /// TODO:
                  /// update firestore user document
                  final uid = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                        'First Name': firstNameController.text,
                        'Last Name': lastNameController.text,
                      });

                  //  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    isLoading = false;
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,

                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),

                        content: Text(loc.usernameUpdatedSuccessfully),
                      ),
                    );
                  }
                  await Future.delayed(const Duration(seconds: 2));

                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => InitialPage()),
                    (route) => false,
                  );
                },

                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,

                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        loc.saveChanges,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        /// LABEL
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),

          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
        ),

        /// TEXT FIELD
        Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: TextField(
            controller: controller,

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              hintText: label,

              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),

                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),

                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),

                borderSide: const BorderSide(color: Colors.green, width: 1.5),
              ),

              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
