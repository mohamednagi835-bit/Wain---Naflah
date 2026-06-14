import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Edit_place_screen.dart';
import 'package:tourism_app/Widgets/Custom_image.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/Widgets/Show_delete_place_dialogue.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class AdminPlacesScreen extends StatefulWidget {
  const AdminPlacesScreen({super.key});

  @override
  State<AdminPlacesScreen> createState() => _AdminPlacesScreenState();
}

class _AdminPlacesScreenState extends State<AdminPlacesScreen> {
  late Stream<QuerySnapshot> placesStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placesStream = FirebaseFirestore.instance.collection('places').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(
          loc.places,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: StreamBuilder(
        stream: placesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(loc.noPlacesYet));
          } else if (snapshot.hasError) {
            return Center(child: Text(loc.thereIsAnError));
          } else {
            List<PlaceModel> placesList = [];
            Timestamp temp;
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              temp = snapshot.data!.docs[i]['createdAt'];
              placesList.add(
                PlaceModel(
                  name: snapshot.data!.docs[i]['title'],
                  description: snapshot.data!.docs[i]['description'],
                  image: snapshot.data!.docs[i]['image'],
                  userName: snapshot.data!.docs[i]['userName'],
                  createdAt: (temp).toDate(),
                  id: snapshot.data!.docs[i].id,
                  likesCount: snapshot.data!.docs[i]['likesCount'],
                  rating: (snapshot.data!.docs[i]['rate'] as num).toDouble(),
                  retersNO: snapshot.data!.docs[i]['ratersCount'],
                  commentCount: snapshot.data!.docs[i]['commentsCount'],
                  lat: (snapshot.data!.docs[i]['latitude'] as num).toDouble(),
                  lon: (snapshot.data!.docs[i]['longitude'] as num).toDouble(),
                  category: snapshot.data!.docs[i]['category'],
                  location: snapshot.data!.docs[i]['location'],
                ),
              );
              //   print(placesList[i].id);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: placesList.length,

              itemBuilder: (context, index) {
                return placeCard(context: context, place: placesList[index]);
              },
            );
          }
        },
      ),
    );
  }

  /// =========================
  /// PLACE CARD
  /// =========================
  ///
  Widget placeCard({required BuildContext context, required PlaceModel place}) {
    final loc = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final enCategories = [
      'All',
      'Mountain',
      'Sea',
      'Beach',
      'Entertainment',
      'Historical',
      'Desert',
      'Otherwise',
    ];
    final arCategories = [
      'الكل',
      'جبل',
      'بحر',
      'شاطئ',
      'ترفيه',
      'تاريخي',
      'صحراء',
      'أخرى',
    ];
    String getCategory(String category, String languageCode) {
      int i;
      for (i = 0; i < enCategories.length; i++) {
        if (category == enCategories[i]) {
          break;
        }
      }
      if (languageCode == 'en') {
        return enCategories[i];
      } else {
        return arCategories[i];
      }
    }

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
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(value: 'Edit', child: Text(loc.edit)),
                        PopupMenuItem(value: 'Delete', child: Text(loc.delete)),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditPlaceScreen(place: place);
                            },
                          ),
                        );
                      }
                      if (value == 'Delete') {
                        showDeletePlaceDialog(context: context, id: place.id);
                      }
                    },
                  ),
                ],
              ),
            ),

            ///  IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(5),
              ),
              child: CustomNetworkImage(imageUrl: place.image),
            ),
            const SizedBox(height: 10),
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            ///  DESCRIPTION
            Text(
              place.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 18,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    getCategory(place.category, localeCode),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// LOCATION
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    place.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        //  place.isLiked
                        Icons.favorite_border_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text('${place.likesCount}'),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.comment_outlined, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text('${place.commentCount}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            /// ACTIONS (EDIT / DELETE)
            // Row(
            //   children: [
            //     /// EDIT
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.green,
            //           //padding: const EdgeInsets.symmetric(vertical: 12),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),

            //         onPressed: () {
            //           /// EDIT PLACE
            //         },

            //         icon: const Icon(Icons.edit, color: Colors.white),
            //         label: const Text(
            //           'Edit',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),

            //     const SizedBox(width: 12),

            //     /// DELETE
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.red,
            //           //padding: const EdgeInsets.symmetric(vertical: 12),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),

            //         onPressed: () {
            //           /// DELETE PLACE

            //           showDeletePlaceDialog(context: context, onConfirm: () {});
            //         },

            //         icon: const Icon(Icons.delete, color: Colors.white),
            //         label: const Text(
            //           'Delete',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
