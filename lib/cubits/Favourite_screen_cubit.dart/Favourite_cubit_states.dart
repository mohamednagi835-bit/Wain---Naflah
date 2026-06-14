import 'package:tourism_app/Models/place.dart';

class FavouriteCubitStates {}

class PlacesLoading extends FavouriteCubitStates {}

class PlacesLoaded extends FavouriteCubitStates {
  List<PlaceModel> places;
  List<String> placesIds;
  PlacesLoaded({required this.places, required this.placesIds});
}

class PlacesError extends FavouriteCubitStates {
  String errMessage;
  PlacesError({required this.errMessage});
}
