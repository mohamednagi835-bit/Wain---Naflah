import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

Future<void> showDeleteUserDialog({
  required BuildContext context,
  required String id,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      final loc = AppLocalizations.of(context)!;

      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: Text(
              loc.blockUser,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            content: Text(loc.blockUserConfirmation),

            actions: [
              /// CANCEL
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(loc.cancel, style: TextStyle(color: Colors.black)),
              ),

              /// DELETE
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () async {
                  if (!context.mounted) return;

                  setState(() {
                    isLoading = true;
                  });

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(id)
                      .update({'isBlocked': 'True'});
                  if (!context.mounted) return;

                  setState(() {
                    isLoading = false;
                  });
                  if (!context.mounted) return;

                  Navigator.pop(context);
                  showSuccessToast(context, loc.blockedSuccessfully);
                },

                child: isLoading
                    ? SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(loc.block, style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
