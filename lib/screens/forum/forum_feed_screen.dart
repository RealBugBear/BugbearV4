// File: lib/screens/forum/forum_feed_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bugbear_app/services/forum_service.dart';
import 'package:bugbear_app/models/forum_post.dart';

class ForumFeedScreen extends StatefulWidget {
  const ForumFeedScreen({Key? key}) : super(key: key);

  @override
  ForumFeedScreenState createState() => ForumFeedScreenState();
}

class ForumFeedScreenState extends State<ForumFeedScreen> {
  bool _isLoading = true;
  String? _error;
  List<ForumPostModel> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final svc = context.read<ForumService>();
      final posts = await svc.fetchPosts();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/forum/new'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Fehler: $_error'))
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (ctx, i) {
                    final p = _posts[i];
                    final formattedDate = DateFormat.yMd().add_jm().format(p.createdAt);
                    return ListTile(
                      title: Text(p.content),
                      subtitle: Text('von ${p.authorName} am $formattedDate'),
                    );
                  },
                ),
    );
  }
}
