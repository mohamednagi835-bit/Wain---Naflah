import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/Initial_page.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool isLoading = false;
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;

    final credential = EmailAuthProvider.credential(
      email: user.email!,

      password: currentPassword,
    );

    /// 🔥 re-login silently
    await user.reauthenticateWithCredential(credential);

    /// 🔥 update password
    await user.updatePassword(newPassword);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,

        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            const Text(
              'Security Settings',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Choose a strong password to keep your account secure.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),

            const SizedBox(height: 40),

            /// CURRENT PASSWORD
            passwordField(
              controller: currentPasswordController,

              label: 'Current Password',

              obscure: obscureCurrent,

              onToggle: () {
                setState(() {
                  obscureCurrent = !obscureCurrent;
                });
              },
            ),

            const SizedBox(height: 24),

            /// NEW PASSWORD
            passwordField(
              controller: newPasswordController,

              label: 'New Password',

              obscure: obscureNew,

              onToggle: () {
                setState(() {
                  obscureNew = !obscureNew;
                });
              },
            ),

            const SizedBox(height: 24),

            /// CONFIRM PASSWORD
            passwordField(
              controller: confirmPasswordController,

              label: 'Confirm Password',

              obscure: obscureConfirm,

              onToggle: () {
                setState(() {
                  obscureConfirm = !obscureConfirm;
                });
              },
            ),

            const SizedBox(height: 40),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  /// VALIDATION
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,

                        behavior: SnackBarBehavior.floating,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),

                        content: const Text('Passwords do not match'),
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }

                  /// TODO:
                  /// change firebase password
                  changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                  final uid = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({'Password': newPasswordController.text});

                  // await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    isLoading = false;
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,

                        behavior: SnackBarBehavior.floating,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),

                        content: const Text('Password updated successfully'),
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
                    : const Text(
                        'Update Password',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
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

        /// FIELD
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
            onChanged: (value) {
              setState(() {});
            },
            controller: controller,

            obscureText: obscure,

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              hintText: 'Enter $label',

              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),

              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: onToggle,

                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,

                        color: Colors.grey[500],
                      ),
                    )
                  : null,

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
