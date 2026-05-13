import 'package:flutter/material.dart';
import 'package:tourism_app/Screens/login_screen.dart';

void showSuccessDialog(BuildContext context, bool isLogin) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must press OK
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ✅ Success Icon with Circle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 60,
                ),
              ),

              const SizedBox(height: 20),

              /// 🎉 Title
              const Text(
                "Success!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// 📄 Message
              isLogin
                  ? Text(
                      "You have logged in successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  : Text(
                      "You have Signed successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

              const SizedBox(height: 25),

              /// 🔘 OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    if (isLogin) {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return HomeScreen();
                      //     },
                      //   ),
                      // );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
