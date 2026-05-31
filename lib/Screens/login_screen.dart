import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Helpers/Handle_error_message.dart';
import 'package:tourism_app/Screens/Dash_board.dart';
import 'package:tourism_app/Screens/Home_screen.dart';
import 'package:tourism_app/Screens/Signup_screen.dart';
import 'package:tourism_app/Widgets/Custom_text_field.dart';
import 'package:tourism_app/Widgets/Error_dialog.dart';
import 'package:tourism_app/Widgets/Launguae_dialog.dart';
import 'package:tourism_app/Widgets/No_internet.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        ///  Title
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              loc.discover,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),

        ///  Language Button
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.language, color: Colors.black, size: 20),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LanguageDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Form(
        autovalidateMode: autovalidateMode,
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.white,
                    //  gives breathing space
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //  Title
                Text(
                  loc.welcomeBack,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),

                const SizedBox(height: 5),

                const SizedBox(height: 35),

                //  Email
                CustomTextField(
                  textEditingController: emailController,
                  hint: loc.email,
                  isPassword: false,
                ),

                const SizedBox(height: 15),

                ///  Password
                CustomTextField(
                  textEditingController: passwordController,
                  hint: loc.password,
                  isPassword: true,
                ),

                const SizedBox(height: 25),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          var auth = FirebaseAuth.instance;
                          UserCredential userCredential = await auth
                              .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          isLoading = false;
                          setState(() {});
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          final doc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get();
                          if (doc['role'] == 'User') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomeScreen();
                                },
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AdminDashboardSimple();
                                },
                              ),
                            );
                          }

                          showSuccessToast(context, 'Loggined successfully');
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          switch (e.code) {
                            case 'user-not-found':
                              showErrorDialog(
                                context,
                                message: getFirebaseErrorMessage(e.code),
                              );

                            case 'wrong-password':
                              showErrorDialog(
                                context,
                                message: getFirebaseErrorMessage(e.code),
                              );

                            case 'email-already-in-use':
                              showErrorDialog(
                                context,
                                message: getFirebaseErrorMessage(e.code),
                              );

                            case 'weak-password':
                              showErrorDialog(
                                context,
                                message: getFirebaseErrorMessage(e.code),
                              );

                            case 'invalid-email':
                              showErrorDialog(
                                context,
                                message: getFirebaseErrorMessage(e.code),
                              );

                            case 'network-request-failed':
                              showNoInternetDialog(context);

                            default:
                              showErrorDialog(context);
                          }
                        }
                      } else {
                        autovalidateMode = AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4,
                            ),
                          )
                        : Text(
                            loc.login,
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                SizedBox(height: 10),

                ///  BEAUTIFUL TOGGLE DIVIDER (INTEGRATED)
                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(loc.or, style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 15),

                ///  Clickable toggle
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: loc.haveAccount,

                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: " ${loc.signUp}",
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showSuccessToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 2),

      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32), // professional green
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            /// ✅ ICON
            const Icon(Icons.check_circle, color: Colors.white),

            const SizedBox(width: 10),

            /// 📝 TEXT
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
