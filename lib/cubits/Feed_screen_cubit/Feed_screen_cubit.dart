import 'dart:async';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/cubits/Feed_screen_cubit/Feed_screen_states.dart';

class FeedScreenCubit extends Cubit<FeddScreenStates> {
  StreamSubscription<QuerySnapshot>? subscription;
  List<PlaceModel> places = [];
  List<String> likedPlacesIds = [];
  FeedScreenCubit() : super(PlacesLoading()) {
    subscribeplaces();
  }
  void subscribeplaces() async {
    await getLilkedPlaces();
    subscription = FirebaseFirestore.instance
        .collection('places')
        .where('isApproved', isEqualTo: 'True')
        .snapshots()
        .listen(
          (snapshot) {
            places.clear();
            for (int i = 0; i < snapshot.docs.length; i++) {
              places.add(PlaceModel.fromFirestore(snapshot.docs[i]));
            }
            emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
            // places = snapshot.docs
            //     .map((doc) => PlaceModel.fromFirestore(doc))
            //     .toList();
            // emit(PlacesLoaded(places: places));
          }, //onError: (e) => emit(PlacesError(errMessage: e.toString()))]
          onError: (e) {
            emit(PlacesError(errMessage: e.toString()));
          },
        );
  }

  Future<void> getLilkedPlaces() async {
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

  void changCategory(String category) {
    if (category != 'All') {
      subscription?.cancel();
      emit(PlacesLoading());
      subscription = FirebaseFirestore.instance
          .collection('places')
          .where('category', isEqualTo: category)
          .snapshots()
          .listen(
            (snapshot) {
              places.clear();
              for (int i = 0; i < snapshot.docs.length; i++) {
                places.add(PlaceModel.fromFirestore(snapshot.docs[i]));
              }
              emit(PlacesLoaded(places: places, placesIds: likedPlacesIds));
              // places = snapshot.docs
              //     .map((doc) => PlaceModel.fromFirestore(doc))
              //     .toList();
              // emit(PlacesLoaded(places: places));
            }, //onError: (e) => emit(PlacesError(errMessage: e.toString()))]
            onError: (e) {
              emit(PlacesError(errMessage: e.toString()));
            },
          );
    } else {
      subscribeplaces();
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    subscription?.cancel();
    return super.close();
  }
}
