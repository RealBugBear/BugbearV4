// File: lib/services/forum_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/models/forum_post.dart';

/// ForumService holt und legt Forenbeiträge pseudonymisiert an.
class ForumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ForumPostModel>> fetchPosts() async {
    final snapshot = await _db
        .collection('forumPosts')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ForumPostModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> createPost(
    String content,
  ) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection('forumPosts').add({
      'userId':    uid,
      'content':   content,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updatePost(
    String postId,
    Map<String, dynamic> updates,
  ) {
    return _db.collection('forumPosts').doc(postId).update(updates);
  }

  Future<void> deletePost(
    String postId,
  ) {
    return _db.collection('forumPosts').doc(postId).delete();
  }
}
