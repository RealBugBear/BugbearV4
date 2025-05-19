// File: lib/models/forum_post.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPostModel {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  ForumPostModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory ForumPostModel.fromMap(
    Map<String, dynamic> data,
    String docId,
  ) {
    return ForumPostModel(
      id: docId,
      userId: data['userId'] as String,
      content: data['content'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  /// In diesem MVP verwenden wir userId als Autorennamen.
  String get authorName => userId;
}
