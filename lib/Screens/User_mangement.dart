import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Models/user.dart';
import 'package:tourism_app/Widgets/Show_delete_place_dialogue.dart';
import 'package:tourism_app/Widgets/Show_delete_user_dialogue.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';

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
                role: snapshot.data!.docs[i]['role'],
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
                role: users[index].role,
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
    required String role,
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

      child: Column(
        children: [
          Row(
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(email, style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: role == 'Admin'
                            ? Colors.orange.withOpacity(.12)
                            : Colors.blue.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            role == 'Admin'
                                ? Icons.admin_panel_settings
                                : Icons.person,
                            size: 14,
                            color: role == 'Admin'
                                ? Colors.orange.shade800
                                : Colors.blue.shade800,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            role,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: role == 'Admin'
                                  ? Colors.orange.shade800
                                  : Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// DELETE BUTTON
              // IconButton(
              //   onPressed: () {
              //     /// DELETE USER ACTION
              //     showDeleteUserDialog(context: context, id: id);
              //   },

              //   icon: const Icon(Icons.delete, color: Colors.red),
              // ),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_horiz, color: Colors.black87),

                itemBuilder: (context) {
                  if (role == 'User') {
                    return [
                      PopupMenuItem(
                        value: 'Promotion',
                        child: Text('Promote to admin'),
                      ),
                      PopupMenuItem(value: 'Delete', child: Text('Delete')),
                    ];
                  } else {
                    return [
                      PopupMenuItem(
                        value: 'Downgrade',
                        child: Text('Downgrade to user'),
                      ),
                      PopupMenuItem(value: 'Delete', child: Text('Delete')),
                    ];
                  }
                },
                onSelected: (value) async {
                  if (value == 'Promotion') {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .update({'role': 'Admin'});
                    if (!context.mounted) return;
                    showSuccessToast(context, 'User promoted successfully');
                  } else if (value == 'Downgrade') {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .update({'role': 'User'});
                    if (!context.mounted) return;
                    showSuccessToast(context, 'User Downgraded successfully');
                  } else if (value == 'Delete') {
                    //   showDeletePlaceDialog(context: context, id: place.id);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
