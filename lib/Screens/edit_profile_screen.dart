import 'package:flutter/material.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController(
    text: "محمد",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "ناجي",
  );
  final TextEditingController emailController = TextEditingController(
    text: "example@email.com",
  );

  final TextEditingController paawordController = TextEditingController(
    text: "Password",
  );

  String selectedGender = "male";

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: Text(loc.editProfile),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👤 PROFILE IMAGE
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 50),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: pick image
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 🏷️ FIRST NAME
              _buildLabel(loc.firstName),
              _buildField(lastNameController, loc.firstName),

              const SizedBox(height: 16),

              /// 🏷️ LAST NAME
              _buildLabel(loc.lastName),
              _buildField(lastNameController, loc.lastName),

              const SizedBox(height: 16),

              /// 🏷️ EMAIL
              _buildLabel(loc.email),
              _buildField(emailController, loc.email),

              const SizedBox(height: 16),

              _buildLabel(loc.password),
              _buildField(paawordController, loc.password),

              const SizedBox(height: 16),

              /// 🏷️ GENDER
              // _buildLabel(loc.gender),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(14),
              //   ),
              //   child: DropdownButtonFormField<String>(
              //     initialValue: selectedGender,
              //     decoration: const InputDecoration(border: InputBorder.none),
              //     items: [
              //       DropdownMenuItem(value: "male", child: Text(loc.male)),
              //       DropdownMenuItem(value: "female", child: Text(loc.female)),
              //     ],
              //     onChanged: (value) {
              //       setState(() {
              //         selectedGender = value!;
              //       });
              //     },
              //   ),
              // ),
              const SizedBox(height: 30),

              /// 💾 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: save to Firebase
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'saves',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏷️ LABEL
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  /// 📝 FIELD
  Widget _buildField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required field";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        // filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
