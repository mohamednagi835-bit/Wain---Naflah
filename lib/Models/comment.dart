enum CommentStatus { sending, sent }

class CommentModel {
  final String userName;
  final String text;
  final DateTime time;
  CommentStatus status;

  CommentModel({
    required this.userName,
    required this.text,
    required this.time,
    this.status = CommentStatus.sent,
  });
}
