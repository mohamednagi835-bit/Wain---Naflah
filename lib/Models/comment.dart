enum CommentStatus { sending, sent }

class CommentModel {
  final String userName;
  final String text;
  CommentStatus status;
  final DateTime createdAt;

  CommentModel({
    required this.userName,
    required this.text,
    this.status = CommentStatus.sent,
    required this.createdAt,
  });
}
