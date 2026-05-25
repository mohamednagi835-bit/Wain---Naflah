import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Models/comment.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Widgets/Custom_image.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/Widgets/Rating_dialog.dart';
import 'package:tourism_app/Widgets/Show_add_favourite.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final PlaceModel place;
  CollectionReference places;
  CollectionReference likedPlaces;
  List<String> placeIDs;

  PlaceDetailsScreen({
    super.key,
    required this.place,
    required this.places,
    required this.likedPlaces,
    required this.placeIDs,
  });

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final TextEditingController commentController = TextEditingController();
  CollectionReference comments = FirebaseFirestore.instance.collection(
    'comments',
  );
  CollectionReference favouritePlacses = FirebaseFirestore.instance.collection(
    'favourite places',
  );
  List<CommentModel> commentsModels = [];

  late Stream<QuerySnapshot> commentStream;
  late Stream<DocumentSnapshot> ratingStream;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    commentStream = comments
        .where('place', isEqualTo: widget.place.id)
        .snapshots();
    ratingStream = widget.places.doc(widget.place.id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      /// 📌 FIX: input moved here to avoid overflow
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          top: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: loc.writeComment,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () async {
                  if (commentController.text.trim().isEmpty) return;
                  // context.read<Likecommentcubit>().addComment(
                  //   place,
                  await comments.add({
                    'content': commentController.text,
                    'createdAt': DateTime.now(),
                    'place': widget.place.id,
                    'user': '${currentUser.firsrName} ${currentUser.lastName}',
                  });
                  await widget.places.doc(widget.place.id).update({
                    'commentsCount': commentsModels.length,
                  });
                  commentController.clear();
                },

                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: commentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            commentsModels.clear();
            Timestamp temp;
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              temp = snapshot.data!.docs[i]['createdAt'];
              commentsModels.add(
                CommentModel(
                  userName: snapshot.data!.docs[i]['user'],
                  text: snapshot.data!.docs[i]['content'],
                  time: temp.toDate(),
                ),
              );
            }
          }
          return SafeArea(
            child: Column(
              children: [
                /// 📸 IMAGE + BACK
                Stack(
                  children: [
                    CustomNetworkImage(
                      imageUrl: widget.place.image,
                      height: 200,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ///  USER HEADER (NEW)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      ///  Avatar
                      // CircleAvatar(
                      //   radius: 22,
                      //   backgroundColor: Colors.grey.shade200,
                      //   backgroundImage: NetworkImage(place.userImage),
                      // ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.person, color: Colors.green),
                      ),
                      const SizedBox(width: 10),

                      ///  Name + time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.place.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              formatTime(context, widget.place.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      PopupMenuButton<String>(
                        color: Colors.white,
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        onSelected: (value) async {
                          if (value == 'rate') {
                            /// ⭐ RATE
                            print("Rate clicked");
                            showRatingDialog(
                              context,
                              widget.place,
                              widget.places,
                            );
                          }

                          if (value == 'favorite') {
                            /// ❤️ ADD TO FAVORITE
                            await favouritePlacses.add({
                              'userid': FirebaseAuth.instance.currentUser!.uid,
                              'place': widget.place.id,
                              // 'title': widget.place.name,
                              // 'description': widget.place.description,
                              // 'commentsCount': widget.place.commentCount,
                              // 'createdAt': widget.place.createdAt,
                              // 'likesCount': widget.place.likesCount,
                              // 'rate': widget.place.rating,
                              // 'ratersCount': widget.place.retersNO,
                              // 'userName': widget.place.userName,
                              // 'userID': uid,
                              // 'image': widget.place.image,
                            });
                            print("Favorite clicked");
                            showFavoriteToast(context);
                          }
                        },

                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'rate',
                            child: Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber),
                                SizedBox(width: 10),
                                Text("Rate"),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: 'favorite',
                            child: Row(
                              children: const [
                                Icon(Icons.favorite, color: Colors.red),
                                SizedBox(width: 10),
                                Text("Add to favourite"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// (optional future)
                      // Icon(Icons.more_vert, color: Colors.grey[600]),
                    ],
                  ),
                ),

                /// 📄 CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🏷️ NAME
                        Text(
                          widget.place.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 📝 DESCRIPTION
                        Text(
                          widget.place.description,
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 16),

                        /// ❤️ + ⭐
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final wasLiked = widget.place.isLiked;

                                    /// 🔥 1. INSTANT LOCAL UPDATE

                                    setState(() {
                                      if (wasLiked) {
                                        widget.place.likesCount--;
                                        widget.placeIDs.remove(widget.place.id);
                                      } else {
                                        widget.place.likesCount++;
                                        widget.placeIDs.add(widget.place.id);
                                      }
                                      widget.place.isLiked =
                                          !widget.place.isLiked;
                                    });

                                    // if(wasLiked) {
                                    //   placeIDs.remove(place.id)

                                    // } else {
                                    //   placeIDs.add(place.id);
                                    // }

                                    try {
                                      /// ❤️ ADD LIKE
                                      if (!wasLiked) {
                                        await widget.likedPlaces.add({
                                          'userId': FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                          'place': widget.place.id,
                                        });
                                      }
                                      /// 💔 REMOVE LIKE
                                      else {
                                        final query = await widget.likedPlaces
                                            .where(
                                              'userId',
                                              isEqualTo: FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            )
                                            .where(
                                              'place',
                                              isEqualTo: widget.place.id,
                                            )
                                            .get();

                                        for (var doc in query.docs) {
                                          await doc.reference.delete();
                                        }
                                      }

                                      /// 🔥 update likes count (server sync)
                                      await widget.places
                                          .doc(widget.place.id)
                                          .update({
                                            'likesCount':
                                                widget.place.likesCount,
                                          });
                                    } catch (e) {
                                      /// ❌ ROLLBACK
                                      setState(() {
                                        if (wasLiked) {
                                          widget.placeIDs.add(widget.place.id);
                                          widget.place.likesCount++;
                                        } else {
                                          widget.placeIDs.remove(
                                            widget.place.id,
                                          );
                                          widget.place.likesCount--;
                                        }
                                      });
                                    }
                                  },
                                  child: Icon(
                                    widget.place.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: widget.place.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text("${widget.place.likesCount}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                StreamBuilder(
                                  stream: ratingStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    final data =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    final rating = data['rate'];
                                    return Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// 💬 HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  loc.comments,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${commentsModels.length}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 10),

                        /// 💬 COMMENTS LIST
                        commentsModels.isEmpty
                            ? Center(
                                child: Text(
                                  loc.noComments,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: commentsModels.length,
                                itemBuilder: (context, index) {
                                  final comment = commentsModels[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              Colors.green.shade100,
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.userName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(comment.text),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
