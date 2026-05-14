import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Models/comment.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Feed_screen.dart';

class Likecommentcubit extends Cubit<List<PlaceModel>> {
  Likecommentcubit() : super([]);

  void setplaces() {
    // emit(dummyPlaces);
  }

  void onlike(PlaceModel place) {
    final updatedList = state.map((p) {
      if (p == place) {
        final isLiked = !p.isLiked;

        return PlaceModel(
          name: p.name,
          description: p.description,
          image: p.image,
          rating: p.rating,
          isLiked: isLiked,
          likesCount: isLiked ? p.likesCount + 1 : p.likesCount - 1,
          commentCount: p.commentCount,
          comments: p.comments,
          userName: p.userName,
          // userImage: p.image,
          createdAt: p.createdAt,
        );
      }
      return p;
    }).toList();

    emit(updatedList);
  }

  void addComment(PlaceModel place, CommentModel comment) {
    final updated = state.map((p) {
      if (p == place) {
        return PlaceModel(
          name: p.name,
          description: p.description,
          image: p.image,
          rating: p.rating,
          isLiked: p.isLiked,
          likesCount: p.likesCount,
          commentCount: p.commentCount + 1,
          comments: [...p.comments, comment],
          userName: p.userName,
          // userImage: p.userImage,
          createdAt: p.createdAt,
        );
      }
      return p;
    }).toList();

    emit(updated);
  }
}
