import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_app/Models/comment.dart';

class PlaceModel {
  final String name;
  final String description;
  final String image;
  double rating;
  bool isLiked;
  int likesCount;
  int commentCount;
  List<CommentModel> comments;
  String userName;
  // String userImage;
  DateTime createdAt;
  int retersNO;
  final String id;
  double lat;
  double lon;
  String category;
  String location;
  PlaceModel({
    required this.name,
    required this.description,
    required this.image,
    this.rating = 0.0,
    this.isLiked = false,
    this.likesCount = 0,
    this.commentCount = 0,
    this.comments = const [],
    required this.userName,
    // required this.userImage,
    required this.createdAt,
    this.retersNO = 0,
    this.id = '',
    this.lat = 0.0,
    this.lon = 0.0,
    this.category = '',
    this.location = '',
  });

  factory PlaceModel.fromFirestore(doc) {
    Timestamp temp = doc['createdAt'];
    return PlaceModel(
      name: doc['title'],
      description: doc['description'],
      image: doc['image'],
      userName: doc['userName'],
      createdAt: temp.toDate(),
      id: doc.id,
      likesCount: doc['likesCount'],
      rating: (doc['rate'] as num).toDouble(),
      retersNO: (doc['ratersCount'] as num).toInt(),
      commentCount: doc['commentsCount'],
      location: doc['location'],
      category: doc['category'],
      lat: (doc['latitude'] as num).toDouble(),
      lon: (doc['longitude'] as num).toDouble(),
      //  isLiked: placesIds.contains(doc.id),
    );
  }
}
