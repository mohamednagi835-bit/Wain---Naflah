import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Home_screen.dart';
import 'package:tourism_app/Screens/Place_detail_screen.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/cubits/likeCommentCubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  //List<PlaceModel> places = dummyPlaces;
  CollectionReference places = FirebaseFirestore.instance.collection('places');

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.home,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                loc.placesDiscover,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        /// 🔘 Actions
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.more_vert, color: Colors.black),

        //     onSelected: (value) {
        //       switch (value) {
        //         case 'language':
        //           // open language dialog
        //           break;

        //         case 'logout':
        //           // handle logout
        //           break;

        //         case 'settings':
        //           // open settings
        //           break;
        //       }
        //     },

        //     itemBuilder: (context) => [

        //       PopupMenuItem(
        //         value: 'language',
        //         child: Text(AppLocalizations.of(context)!.language),
        //       ),
        //       PopupMenuItem(
        //         value: 'settings',
        //         child: Text(AppLocalizations.of(context)!.settings),
        //       ),
        //       PopupMenuItem(
        //         value: 'logout',
        //         child: Text(AppLocalizations.of(context)!.logout),
        //       ),
        //     ],
        //   ),

        //   const SizedBox(width: 8),
        // ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: places.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No places yet.'));
          } else if (snapshot.hasError) {
            return Center(child: Text('There is an error'));
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
                  userName: currentUser.firsrName + ' ${currentUser.lastName}',
                  createdAt: (temp).toDate(),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: placesList.length,
              itemBuilder: (context, index) {
                return PlaceCard(place: placesList[index], onLike: () {});
              },
            );
          }
        },
      ),

      // BlocBuilder<Likecommentcubit, List<PlaceModel>>(
      //   builder: (context, state) {
      //     return ListView.builder(
      //       padding: const EdgeInsets.all(16),
      //       itemCount: state.length,
      //       itemBuilder: (context, index) {
      //         PlaceModel place = state[index];
      //         return GestureDetector(
      //           onTap: () async {
      //             await getUser();
      //             // final docRef = places.doc();

      //             // print(docRef.id);

      //             // await docRef.set({
      //             //   'title': place.name,
      //             //   'description': place.description,
      //             //   'likesCount': place.likesCount,
      //             //   'commentsCount': place.commentCount,
      //             //   'ratersCount': place.retersNO,
      //             //   'rate': place.rating,
      //             //   'createdAt': place.createdAt,
      //             //   'image': place.image,
      //             //   'userName':
      //             //       currentUser.firsrName + ' ${currentUser.lastName}',
      //             // });

      //             await places.add({
      //               // add place
      //               'title': place.name,
      //               'description': place.description,
      //               'likesCount': place.likesCount,
      //               'commentsCount': place.commentCount,
      //               'ratersCount': place.retersNO,
      //               'rate': place.rating,
      //               'createdAt': place.createdAt,
      //               'image': place.image,
      //               'userName':
      //                   currentUser.firsrName + ' ${currentUser.lastName}',
      //             });
      //             // final snapshot = await FirebaseFirestore.instance
      //             //     .collection('places')
      //             //     .get();
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) {
      //                   return PlaceDetailsScreen(place: place);
      //                 },
      //               ),
      //             );
      //           },
      //           child: PlaceCard(
      //             place: place,
      //             onLike: () {
      //               context.read<Likecommentcubit>().onlike(place);
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

// final List<PlaceModel> dummyPlaces = [
//   PlaceModel(
//     name: "العلا",
//     description:
//         "مدينة تاريخية ساحرة تضم آثارًا قديمة وتكوينات صخرية مذهلة في قلب الصحراء.",
//     image: "https://share.google/qiEmvySGkKhmAoikW",
//     rating: 4.9,
//   ),
//   PlaceModel(
//     name: "بوليفارد الرياض",
//     description:
//         "وجهة ترفيهية حديثة تحتوي على مطاعم عالمية وفعاليات مميزة تناسب جميع الأعمار.",
//     image: "https://images.unsplash.com/photo-1591608971362-f08b2a75731a",
//     rating: 3.7,
//   ),
//   PlaceModel(
//     name: "كورنيش جدة",
//     description:
//         "ممشى ساحلي رائع بإطلالة مباشرة على البحر الأحمر، مثالي للعائلات والتنزه.",
//     image: "https://images.unsplash.com/photo-1580674285054-bed31e145f59",
//     rating: 2.6,
//   ),
//   PlaceModel(
//     name: "جبال فيفا",
//     description:
//         "جبال خضراء خلابة تتميز بالمدرجات الزراعية والأجواء الضبابية الساحرة.",
//     image: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
//     rating: 4.8,
//   ),
//   PlaceModel(
//     name: "الدرعية التاريخية",
//     description:
//         "موقع تراثي يعكس تاريخ المملكة ويضم مباني طينية قديمة وأسواق تقليدية.",
//     image: "https://images.unsplash.com/photo-1549893079-842e7b6a4d3d",
//     rating: 1.7,
//   ),
//   PlaceModel(
//     name: "شاطئ نصف القمر",
//     description:
//         "شاطئ هادئ بمياه صافية ورمال ذهبية، مناسب للاسترخاء والأنشطة البحرية.",
//     image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
//     rating: 4.5,
//   ),
//   PlaceModel(
//     name: "وادي لجب",
//     description:
//         "وادي طبيعي مذهل تحيط به الجبال الشاهقة ويعد من أجمل المواقع لمحبي المغامرة.",
//     image: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
//     rating: 4.8,
//   ),
// ];

// final List<PlaceModel> dummyPlaces = [
//   PlaceModel(
//     name: "العلا",
//     description:
//         "مدينة تاريخية ساحرة تضم آثارًا قديمة وتكوينات صخرية مذهلة في قلب الصحراء.",
//     image: "https://images.unsplash.com/photo-1609948543911-5f1a0c5c9c7c",
//     rating: 4.9,
//     userName: "محمد أحمد",
//     userImage: "https://randomuser.me/api/portraits/men/32.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "بوليفارد الرياض",
//     description:
//         "وجهة ترفيهية حديثة تحتوي على مطاعم عالمية وفعاليات مميزة تناسب جميع الأعمار.",
//     image: "https://images.unsplash.com/photo-1591608971362-f08b2a75731a",
//     rating: 3.7,
//     userName: "Sarah Ali",
//     userImage: "https://randomuser.me/api/portraits/women/44.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "كورنيش جدة",
//     description:
//         "ممشى ساحلي رائع بإطلالة مباشرة على البحر الأحمر، مثالي للعائلات والتنزه.",
//     image: "https://images.unsplash.com/photo-1580674285054-bed31e145f59",
//     rating: 2.6,
//     userName: "Omar Khaled",
//     userImage: "https://randomuser.me/api/portraits/men/55.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "جبال فيفا",
//     description:
//         "جبال خضراء خلابة تتميز بالمدرجات الزراعية والأجواء الضبابية الساحرة.",
//     image: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
//     rating: 4.8,
//     userName: "Fatima Noor",
//     userImage: "https://randomuser.me/api/portraits/women/68.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "الدرعية التاريخية",
//     description:
//         "موقع تراثي يعكس تاريخ المملكة ويضم مباني طينية قديمة وأسواق تقليدية.",
//     image: "https://images.unsplash.com/photo-1549893079-842e7b6a4d3d",
//     rating: 1.7,
//     userName: "Ahmed Hassan",
//     userImage: "https://randomuser.me/api/portraits/men/77.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "شاطئ نصف القمر",
//     description:
//         "شاطئ هادئ بمياه صافية ورمال ذهبية، مناسب للاسترخاء والأنشطة البحرية.",
//     image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
//     rating: 4.5,
//     userName: "Lina Saad",
//     userImage: "https://randomuser.me/api/portraits/women/21.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   PlaceModel(
//     name: "وادي لجب",
//     description:
//         "وادي طبيعي مذهل تحيط به الجبال الشاهقة ويعد من أجمل المواقع لمحبي المغامرة.",
//     image: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
//     rating: 4.8,
//     userName: "Yousef Ali",
//     userImage: "https://randomuser.me/api/portraits/men/12.jpg",
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
// ];
