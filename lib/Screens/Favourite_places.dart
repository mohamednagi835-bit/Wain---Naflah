import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Place_detail_screen.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/cubits/Favourite_screen_cubit.dart/Favourite_cubit_states.dart';
import 'package:tourism_app/cubits/Favourite_screen_cubit.dart/Favourite_screen_cubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class FavouritePlaces extends StatelessWidget {
  const FavouritePlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => FavouriteScreenCubit(),
      child: Scaffold(
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
                  loc.myPlaces,
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
        ),
        body: BlocBuilder<FavouriteScreenCubit, FavouriteCubitStates>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EmptyPlaces) {
              return Center(child: Text(loc.noPlacesYet));
            } else if (state is PlacesLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.places.length,
                itemBuilder: (context, index) {
                  PlaceModel place = state.places[index];
                  place.isLiked = state.placesIds.contains(place.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlaceDetailsScreen(
                              place: place,
                              placeIDs: state.placesIds,
                            );
                          },
                        ),
                      );
                    },
                    child: PlaceCard(
                      place: place,
                      onLike: () {
                        context.read<FavouriteScreenCubit>().toggleLike(place);
                      },
                    ),
                  );
                },
              );
            } else {
              return Text(
                'There is an error',
                style: TextStyle(fontSize: 24, color: Colors.black),
              );
            }
          },
        ),
      ),
    );
  }
}
