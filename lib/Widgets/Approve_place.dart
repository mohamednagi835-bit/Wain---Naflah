import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

Future<void> showApprvePlace({
  required BuildContext context,
  required String id,
}) async {
  bool isLoading = false;
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final loc = AppLocalizations.of(context)!;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: Text(
              loc.approvePlace,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            content: Text(loc.approvePlaceConfirmation),

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                ),

                onPressed: () async {
                  isLoading = true;
                  setState(() {});

                  await FirebaseFirestore.instance
                      .collection('places')
                      .doc(id)
                      .update({'isApproved': 'True'});
                  isLoading = false;
                  setState(() {});
                  if (!context.mounted) return;
                  showSuccessToast(context, loc.placeApprovedSuccessfully);
                  if (!context.mounted) return;
                  Navigator.pop(context);
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
                    : Text(loc.approve, style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
