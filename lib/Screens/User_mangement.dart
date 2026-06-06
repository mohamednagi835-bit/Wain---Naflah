import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Models/user.dart';
import 'package:tourism_app/Widgets/Show_delete_user_dialogue.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Stream<QuerySnapshot> usersStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

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

      body: StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Center(child: CircularProgressIndicator()));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users yet.'));
          } else if (snapshot.hasError) {
            return Center(child: Text('There is an error'));
          }
          List<AppuUSer> users = [];
          for (int i = 0; i < snapshot.data!.size; i++) {
            users.add(
              AppuUSer(
                email: snapshot.data!.docs[i]['email'],
                paaword: snapshot.data!.docs[i]['Password'],
                firsrName: snapshot.data!.docs[i]['First Name'],
                lastName: snapshot.data!.docs[i]['Last Name'],
                phoneNumber: snapshot.data!.docs[i]['Phone Number'],
                id: snapshot.data!.docs[i].id,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,

            itemBuilder: (context, index) {
              String fullName =
                  '${users[index].firsrName} ${users[index].lastName}';
              return userCard(
                context: context,
                email: users[index].email,
                userName: fullName,
                id: users[index].id,
              );
            },
          );
        },
      ),
    );
  }

  /// =========================
  /// USER CARD
  /// =========================
  Widget userCard({
    required BuildContext context,
    required String email,
    required String userName,
    required String id,
  }) {
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
          // Avatar
          const CircleAvatar(radius: 26, child: Icon(Icons.person)),

          const SizedBox(width: 14),

          // NAME + EMAIL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4),

                Text(email, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          /// DELETE BUTTON
          IconButton(
            onPressed: () {
              /// DELETE USER ACTION
              showDeleteUserDialog(context: context, id: id);
            },

            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
