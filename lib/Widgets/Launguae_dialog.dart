import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/cubits/ChangeLanguagCubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String selectedLang = 'en';

  @override
  void initState() {
    super.initState();
    selectedLang = context.read<Changelanguagcubit>().state.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.langSelect),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: 'en',
            // ignore: deprecated_member_use
            groupValue: selectedLang,
            // ignore: deprecated_member_use
            onChanged: (value) {
              setState(() {
                selectedLang = value!;
              });
            },
            title: Text(loc.english),
          ),

          RadioListTile(
            value: 'ar',
            // ignore: deprecated_member_use
            groupValue: selectedLang,
            // ignore: deprecated_member_use
            onChanged: (value) {
              setState(() {
                selectedLang = value!;
              });
            },
            title: Text(loc.arabic),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(loc.cancel),
        ),

        ElevatedButton(
          onPressed: () {
            context.read<Changelanguagcubit>().chanlang(selectedLang);
            Navigator.pop(context);
          },
          child: Text(loc.ok, style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}