import 'package:flutter/material.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

String getFirebaseErrorMessage(String code, BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  switch (code) {
    case 'user-not-found':
      return loc.noAccountFoundWithThisEmail;

    case 'wrong-password':
      return loc.incorrectPassword;

    case 'email-already-in-use':
      return loc.emailAlreadyRegistered;

    case 'weak-password':
      return loc.passwordTooWeak;

    case 'invalid-email':
      return loc.invalidEmailFormat;

    case 'network-request-failed':
      return loc.noInternetConnection;

    default:
      return loc.somethingWentWrong;
  }
}
