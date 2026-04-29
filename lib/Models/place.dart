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

  PlaceModel({
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    this.isLiked = false,
    this.likesCount = 0,
    this.commentCount = 0,
    this.comments = const [],
  });
}
