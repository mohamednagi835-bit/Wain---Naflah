import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_delete_user_dialogue.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,

        itemBuilder: (context, index) {
          return userCard(context);
        },
      ),
    );
  }

  /// =========================
  /// USER CARD
  /// =========================
  Widget userCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          /// Avatar
          const CircleAvatar(radius: 26, child: Icon(Icons.person)),

          const SizedBox(width: 14),

          /// NAME + EMAIL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: const [
                Text(
                  'User Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4),

                Text('user@email.com', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          /// DELETE BUTTON
          IconButton(
            onPressed: () {
              /// DELETE USER ACTION
              showDeleteUserDialog(context: context, onConfirm: () {});
            },

            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
