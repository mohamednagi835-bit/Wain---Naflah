import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Models/comment.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Widgets/Custom_image.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/Widgets/Rating_dialog.dart';
import 'package:tourism_app/cubits/likeCommentCubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final PlaceModel place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<Likecommentcubit, List<PlaceModel>>(
      builder: (context, state) {
        final place = state.firstWhere((p) => p.name == widget.place.name);

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
                    onPressed: () {
                      if (commentController.text.trim().isEmpty) return;

                      context.read<Likecommentcubit>().addComment(
                        place,
                        CommentModel(
                          userName: "محمد ناجي",
                          text: commentController.text,
                          time: DateTime.now(),
                        ),
                      );

                      commentController.clear();
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          body: SafeArea(
            child: Column(
              children: [
                /// 📸 IMAGE + BACK
                Stack(
                  children: [
                    CustomNetworkImage(
                      imageUrl: place.image,
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
                              place.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              formatTime(context, place.createdAt),
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

                        onSelected: (value) {
                          if (value == 'rate') {
                            /// ⭐ RATE
                            print("Rate clicked");
                            showRatingDialog(context);
                          }

                          if (value == 'favorite') {
                            /// ❤️ ADD TO FAVORITE
                            print("Favorite clicked");
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
                          place.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 📝 DESCRIPTION
                        Text(
                          place.description,
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
                                  onTap: () {
                                    context.read<Likecommentcubit>().onlike(
                                      place,
                                    );
                                  },
                                  child: Icon(
                                    place.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: place.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text("${place.likesCount}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  place.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                "${place.comments.length}",
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
                        place.comments.isEmpty
                            ? Center(
                                child: Text(
                                  loc.noComments,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: place.comments.length,
                                itemBuilder: (context, index) {
                                  final comment = place.comments[index];

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
                                          radius: 18,
                                          backgroundColor:
                                              Colors.green.shade200,
                                          child: Text(
                                            comment.userName[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
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
          ),
        );
      },
    );
  }
}
