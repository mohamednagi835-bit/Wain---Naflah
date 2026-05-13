import 'package:flutter/material.dart';

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // must press OK
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 📡 Icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.wifi_off, color: Colors.red, size: 60),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// Message
              const Text(
                "Please check your internet connection.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),

              const SizedBox(height: 25),

              /// 🔘 OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
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
