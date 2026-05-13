import 'package:flutter/material.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String fullNumber)? onChanged;

  const PhoneNumberField({super.key, required this.controller, this.onChanged});

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String selectedKey = "+966";

  final List<String> keys = [
    "+1", // USA / Canada
    "+44", // UK
    "+49", // Germany
    "+33", // France
    "+39", // Italy
    "+34", // Spain

    "+20", // Egypt
    "+966", // Saudi Arabia
    "+971", // UAE
    "+974", // Qatar
    "+965", // Kuwait

    "+90", // Turkey
    "+7", // Russia
    "+381", // Serbia

    "+91", // India
    "+92", // Pakistan
    "+880", // Bangladesh

    "+86", // China
    "+81", // Japan
    "+82", // South Korea

    "+55", // Brazil
    "+52", // Mexico

    "+234", // Nigeria
    "+27", // South Africa
  ];
  void _updateFullNumber() {
    final full = "$selectedKey${widget.controller.text}";
    widget.onChanged?.call(full);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateFullNumber);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateFullNumber);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            /// 🌍 Country Code Dropdown
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedKey,
                items: keys.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(
                      key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKey = value!;
                  });
                  _updateFullNumber();
                },
              ),
            ),

            const SizedBox(width: 8),

            /// Divider
            Container(height: 24, width: 1, color: Colors.grey.shade400),

            const SizedBox(width: 8),

            /// 📱 Phone Number Input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return loc.requiredField;
                    } else {
                      return null;
                    }
                  },
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter phone number",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
