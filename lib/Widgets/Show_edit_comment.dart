import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

Future<void> showEditCommentBottomSheet({
  required BuildContext context,
  required String initialComment,
  required String commentId,
}) async {
  final controller = TextEditingController(text: initialComment);
  final loc = AppLocalizations.of(context)!;
  bool isLoading = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.editComment,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  loc.updateYourComment,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: controller,
                  maxLines: 4,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: loc.writeComment,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection('comments')
                          .doc(commentId)
                          .update({'content': text});
                      setState(() {
                        isLoading = false;
                      });
                      showSuccessToast(context, loc.commentEditedSuccessfully);

                      Navigator.pop(context);
                    },
                    child: isLoading == true
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Text(loc.saveChanges),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
