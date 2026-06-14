import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/cubits/Favourite_screen_cubit.dart/Favourite_cubit_states.dart';

class FavouriteScreenCubit extends Cubit<FavouriteCubitStates> {
  StreamSubscription<QuerySnapshot>? subscription;
  List<PlaceModel> places = [];
  List<String> favouritePlacesIds = [];
  //List<String> likedPlaces = [];
  FavouriteScreenCubit() : super(PlacesLoading()) {
    subscribeplaces();
  }

  Future<void> getFavouritePlaces() async {
    favouritePlacesIds.clear();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final favouriteSnap = await FirebaseFirestore.instance
        .collection('favourite places')
        .where('userid', isEqualTo: uid)
        .get();
    if (favouriteSnap.docs.isEmpty) {
      return;
    } else {
      for (int i = 0; i < favouriteSnap.docs.length; i++) {
        favouritePlacesIds.add(favouriteSnap.docs[i]['place'] as String);
      }
    }
  }
  // .where(FieldPath.documentId, whereIn: favouritePlacesIds)

  void subscribeplaces() async {
    //  await getLilkedPlaces();
    await getFavouritePlaces();
    subscription = FirebaseFirestore.instance
        .collection('places')
        .where('isApproved', isEqualTo: 'True')
        .where(FieldPath.documentId, whereIn: favouritePlacesIds)
        .snapshots()
        .listen(
          (snapshot) {
            places.clear();
            for (int i = 0; i < snapshot.docs.length; i++) {
              places.add(PlaceModel.fromFirestore(snapshot.docs[i]));
            }
            emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
          },
          onError: (e) {
            emit(PlacesError(errMessage: e.toString()));
          },
        );
  }

  Future<void> getLilkedPlaces() async {
    likedPlacesIds.clear();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final likesSnap = await FirebaseFirestore.instance
        .collection('liked places')
        .where('userId', isEqualTo: uid)
        .get();
    for (int i = 0; i < likesSnap.docs.length; i++) {
      likedPlacesIds.add(likesSnap.docs[i]['place'] as String);
    }
  }

  void toggleLike(PlaceModel place) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    bool wasLiked = place.isLiked;
    int index = 0;
    if (wasLiked == false) {
      likedPlacesIds.add(place.id);
      place.likesCount++;
    } else {
      likedPlacesIds.remove(place.id);
      place.likesCount--;
    }
    place.isLiked = likedPlacesIds.contains(place.id);
    for (int i = 0; i < places.length; i++) {
      if (place.id == places[i].id) {
        index = i;
        break;
      }
    }
    places[index] = place;
    emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
    if (wasLiked == false) {
      await FirebaseFirestore.instance.collection('liked places').add({
        'place': place.id,
        'userId': uid,
      });
    } else {
      final query = await FirebaseFirestore.instance
          .collection('liked places')
          .where('userId', isEqualTo: uid)
          .where('place', isEqualTo: place.id)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.delete();
      }
    }
    await FirebaseFirestore.instance.collection('places').doc(place.id).update({
      'likesCount': place.likesCount,
    });
  }

  // void changCategory(String category) {
  //   if (category != 'All') {
  //     subscription?.cancel();
  //     emit(PlacesLoading());
  //     subscription = FirebaseFirestore.instance
  //         .collection('places')
  //         .where('category', isEqualTo: category)
  //         .snapshots()
  //         .listen(
  //           (snapshot) {
  //             places.clear();
  //             for (int i = 0; i < snapshot.docs.length; i++) {
  //               places.add(PlaceModel.fromFirestore(snapshot.docs[i]));
  //             }
  //             emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
  //           },
  //           onError: (e) {
  //             emit(PlacesError(errMessage: e.toString()));
  //           },
  //         );
  //   } else {
  //     subscription?.cancel();
  //     subscription = FirebaseFirestore.instance
  //         .collection('places')
  //         .where('isApproved', isEqualTo: 'True')
  //         .snapshots()
  //         .listen(
  //           (snapshot) {
  //             places.clear();
  //             for (int i = 0; i < snapshot.docs.length; i++) {
  //               places.add(PlaceModel.fromFirestore(snapshot.docs[i]));
  //             }
  //             emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
  //           },
  //           onError: (e) {
  //             emit(PlacesError(errMessage: e.toString()));
  //           },
  //         );
  //   }
  // }

  @override
  Future<void> close() {
    // TODO: implement close
    subscription?.cancel();
    return super.close();
  }
}
