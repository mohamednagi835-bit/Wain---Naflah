import 'package:flutter/material.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Widgets/Custom_image.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final Function() onLike;

  const PlaceCard({super.key, required this.place, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///  USER HEADER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ///  Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.person, color: Colors.green),
                ),

                // CircleAvatar(
                //   radius: 20,
                //   backgroundColor: Colors.grey.shade200,
                //   backgroundImage: NetworkImage(place.userImage),
                // ),
                const SizedBox(width: 10),

                ///  Name + Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// (you can later replace this with time/location)
                      Text(
                        formatTime(context, place.createdAt),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///  IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(0),
              bottom: Radius.circular(0),
            ),
            child: CustomNetworkImage(imageUrl: place.image),
          ),

          /// 📄 CONTENT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🏷️ NAME + ⭐ RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < place.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),

                        const SizedBox(width: 4),

                        Text(
                          place.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// 📝 DESCRIPTION
                Text(
                  place.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                /// ❤️ ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 150),
                        child: Row(
                          children: [
                            Icon(
                              place.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: place.isLiked ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text("${place.likesCount}"),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text("${place.commentCount}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatTime(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).languageCode;
  final diff = DateTime.now().difference(date);

  if (diff.inDays > 7) {
    return "${date.day}/${date.month}/${date.year}";
  }

  return timeago.format(date, locale: locale);
}
