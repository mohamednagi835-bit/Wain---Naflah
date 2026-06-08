import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';

Future<void> showRejectPlace({
  required BuildContext context,
  required String id,
}) async {
  bool isLoading = false;
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: const Text(
              'Reject Place',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            content: const Text(
              'Are you sure you want to reject this place? The place will not be published in the application.',
            ),

            actions: [
              /// CANCEL
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              /// DELETE
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () async {
                  isLoading = true;
                  setState(() {});

                  await FirebaseFirestore.instance
                      .collection('places')
                      .doc(id)
                      .delete();
                  isLoading = false;
                  setState(() {});
                  if (!context.mounted) return;
                  showSuccessToast(context, 'Place rejected successfully');
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
                    : Text('Reject', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
