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
  });
}
