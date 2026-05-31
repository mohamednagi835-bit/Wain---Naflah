import 'package:flutter/material.dart';

Future<void> showDeleteUserDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

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
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),

          /// DELETE
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            onPressed: () {
              Navigator.pop(context); // close dialog
              onConfirm(); // execute delete
            },

            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
