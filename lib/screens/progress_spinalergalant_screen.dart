import 'package:flutter/material.dart';
import 'package:bugbear_app/models/training_session.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressSpinalergalantScreen extends StatelessWidget {
  const ProgressSpinalergalantScreen({super.key});
  final String trainingType = "spinalergalant";

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Spinalergalant Progress")),
        body: const Center(child: Text("User not logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Spinalergalant Progress")),
      body: StreamBuilder<List<TrainingSession>>(
        stream: TrainingService().getTrainingSessions(
          userId: currentUser.uid,
          trainingType: trainingType,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final sessions = snapshot.data!;
          int count = sessions.length;
          return Center(
            child: Text(
              "You have completed Spinalergalant training $count times.",
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
