import 'package:flutter/material.dart';
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
          /// 📸 Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CustomNetworkImage(imageUrl: place.image),
          ),

          /// 📄 Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🏷️ Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🏷️ Name
                    Expanded(
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// ⭐ Rating
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

                /// 📝 Description
                Text(
                  place.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                /// ❤️ Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: onLike,
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

                    GestureDetector(
                      onTap: () {
                        // TODO: open comments screen
                      },
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
