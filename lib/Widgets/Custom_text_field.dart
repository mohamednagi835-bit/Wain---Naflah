// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController textEditingController;
  String hint;
  bool isPassword;
  String? label;

  CustomTextField({
    super.key,
    required this.textEditingController,
    required this.hint,
    this.isPassword = false,
    this.label,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
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
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return loc.requiredField;
                } else if (value.isNotEmpty) {
                  if (widget.isPassword == true) {}
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },

              // onChanged: (value) {
              //   setState(() {});
              //   if (widget.isPassword) {
              //     password = value;
              //   } else {
              //     email = value;
              //   }
              // },
              controller: widget.textEditingController,
              obscureText: isObscure & widget.isPassword,
              decoration: InputDecoration(
                suffixIcon:
                    widget.isPassword &&
                        widget.textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        tooltip: isObscure ? loc.showPass : loc.hidePass,
                      )
                    : null,
                hint: Directionality(
                  textDirection: Directionality.of(context),
                  child: Text(widget.hint),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
