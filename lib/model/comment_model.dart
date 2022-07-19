import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String movieId;
  String content;
  Timestamp? date;

  Comment(
    this.userId,
    this.movieId,
    this.content, {
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movieId': movieId,
      'content': content,
      'date': date ?? DateTime.now(),
    };
  }

  Comment.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        movieId = map['movieId'],
        content = map['content'],
        date = map['date'] ?? DateTime.now();
}
