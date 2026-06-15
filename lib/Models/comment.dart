enum CommentStatus { sending, sent }

class CommentModel {
  final String userName;
  final String text;
  CommentStatus status;
  final DateTime createdAt;
  final String userId;
  final String id;

  CommentModel({
    required this.userName,
    required this.text,
    this.status = CommentStatus.sent,
    required this.createdAt,
    required this.userId,
    required this.id,
  });
}
