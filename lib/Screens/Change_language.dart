import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/cubits/ChangeLanguagCubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<ChangeLanguage> {
  String selectedLang = 'en'; // default

  @override
  void initState() {
    super.initState();
    selectedLang = context.read<Changelanguagcubit>().state.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      /// 🏷️ AppBar
      appBar: AppBar(
        title: Text(
          loc.language,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      /// 📄 Body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🌍 OPTIONS
            _buildOption(title: "English", subtitle: "الإنجليزية", value: "en"),

            const SizedBox(height: 12),

            _buildOption(title: "العربية", subtitle: "Arabic", value: "ar"),

            const Spacer(),

            /// 💾 SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<Changelanguagcubit>().chanlang(selectedLang);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  loc.save,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌍 OPTION TILE
  Widget _buildOption({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = selectedLang == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLang = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            /// 🌍 ICON
            CircleAvatar(
              backgroundColor: isSelected ? Colors.green : Colors.grey.shade200,
              child: Icon(
                Icons.language,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            /// 📝 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),

            /// ✅ CHECK
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
