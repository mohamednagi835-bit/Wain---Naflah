import 'package:flutter/material.dart';

Widget buildOtpField({
  required TextEditingController controller,
  required Function(String) onChanged,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Column(
      children: [
        ///  Hidden input
        Opacity(
          opacity: 0,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofocus: true,
              onChanged: onChanged,
            ),
          ),
        ),

        ///  Visible OTP UI
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            String digit = "";
            if (index < controller.text.length) {
              digit = controller.text[index];
            }

            return Column(
              children: [
                Text(
                  digit,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                /// "_" line
                Container(width: 30, height: 2, color: Colors.black),
              ],
            );
          }),
        ),
      ],
    ),
  );
}
