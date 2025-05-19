// File: lib/screens/forum/new_post_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/services/forum_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  NewPostScreenState createState() => NewPostScreenState();
}

class NewPostScreenState extends State<NewPostScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final svc = context.read<ForumService>();
      await svc.createPost(content);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuer Beitrag')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Inhalt'),
              maxLines: 5,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Posten'),
            ),
          ],
        ),
      ),
    );
  }
}
