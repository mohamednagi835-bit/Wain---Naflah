import 'package:tourism_app/Models/place.dart';

class FeddScreenStates {}

class PlacesLoading extends FeddScreenStates {}

class PlacesLoaded extends FeddScreenStates {
  List<PlaceModel> places;
  List<String> placesIds;
  PlacesLoaded({required this.places, required this.placesIds});
}

class EmptyPlaces extends FeddScreenStates {}

class PlacesError extends FeddScreenStates {
  String errMessage;
  PlacesError({required this.errMessage});
}
