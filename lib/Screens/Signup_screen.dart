import 'package:flutter/material.dart';
import 'package:tourism_app/Models/user.dart';
import 'package:tourism_app/Screens/login_screen.dart';
import 'package:tourism_app/Widgets/Custom_text_field.dart';
import 'package:tourism_app/Widgets/Launguae_dialog.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        /// 🏷️ Title
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

        /// 🌍 Language Button
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
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// 🟢 Logo
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🏷️ Title
                Text(
                  loc.createAccount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                /// 👤 First Name
                CustomTextField(
                  textEditingController: firstNameController,
                  hint: loc.firstName,
                  label: loc.firstName,
                ),

                const SizedBox(height: 15),

                /// 👤 Last Name
                CustomTextField(
                  textEditingController: lastNameController,
                  hint: loc.lastName,
                  label: loc.lastName,
                ),

                const SizedBox(height: 15),

                /// 📧 Email
                CustomTextField(
                  textEditingController: emailController,
                  hint: loc.email,
                  label: loc.email,
                ),

                const SizedBox(height: 15),

                /// 🔑 Password
                CustomTextField(
                  textEditingController: passwordController,
                  hint: loc.password,
                  isPassword: true,
                  label: loc.password,
                ),

                const SizedBox(height: 15),

                /// 🚻 Gender Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        loc.gender,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  //  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    decoration: const InputDecoration(border: InputBorder.none),
                    hint: Text(loc.gender),
                    items: [
                      DropdownMenuItem(value: "male", child: Text(loc.male)),
                      DropdownMenuItem(
                        value: "female",
                        child: Text(loc.female),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return loc.requiredField;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 25),

                /// 🔘 Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        User currentUser = User(
                          email: emailController.text,
                          paaword: passwordController.text,
                          firsrName: firstNameController.text,
                          lastName: lastNameController.text,
                          gender: selectedGender!,
                        );
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");
                        print("First: ${firstNameController.text}");
                        print("Last: ${lastNameController.text}");
                        print("Gender: $selectedGender");
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.onUserInteraction;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      loc.signUp,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔄 Back to Login
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: loc.alredylog,

                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: " ${loc.login}",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
