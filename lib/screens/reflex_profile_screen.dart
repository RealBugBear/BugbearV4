// File: lib/screens/reflex_profile_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bugbear_app/models/reflex_category.dart';

/// Zeigt das gespeicherte Reflex-Profil (Scores) an.
class ReflexProfileScreen extends StatefulWidget {
  const ReflexProfileScreen({Key? key}) : super(key: key);

  @override
  State<ReflexProfileScreen> createState() => _ReflexProfileScreenState();
}

class _ReflexProfileScreenState extends State<ReflexProfileScreen> {
  List<ReflexCategory> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedResults();
  }

  Future<void> _loadSavedResults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('savedResults');
    if (jsonString != null) {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      _categories = list
          .map((e) => ReflexCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reflex-Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _categories.isEmpty
                  ? const Center(child: Text('Keine gespeicherten Ergebnisse'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Reflex-Profil',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ..._categories.map((cat) {
                          final pct = cat.score.clamp(0.0, 100.0);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    cat.name,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Text('${pct.toStringAsFixed(1)} %'),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    value: pct / 100,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
            ),
    );
  }
}
