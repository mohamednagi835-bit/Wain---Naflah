import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';

Future<void> showDeleteUserDialog({
  required BuildContext context,
  required String id,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: const Text(
              'Delete User?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            content: const Text(
              'Are you sure you want to delete this user? This action cannot be undone.',
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
                      .collection('users')
                      .doc(id)
                      .delete();
                  isLoading = false;
                  setState(() {});
                  Navigator.pop(context);
                  showSuccessToast(context, 'Deleted successfully');
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
                    : Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
