import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/services/local_storage_service.dart';

class SettingsScreen extends StatelessWidget {
  final TrainingService trainingService;
  final LocalStorageService localStorage;
  final FirebaseAuth auth;

  const SettingsScreen({
    Key? key,
    TrainingService? trainingService,
    LocalStorageService? localStorage,
    FirebaseAuth? auth,
  })  : trainingService = trainingService ?? const TrainingService(),
        localStorage = localStorage ?? const LocalStorageService(),
        auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  Future<void> _resetTraining(BuildContext ctx) async {
    final u = auth.currentUser;
    if (u != null) {
      await trainingService.deleteAllSessions(u.uid);
      await localStorage.clearCompletedDates();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(S.of(ctx).confirmResetAll)),
      );
    }
  }

  Future<void> _clearLocal(BuildContext ctx) async {
    await localStorage.clearAll();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(S.of(ctx).clearLocalData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: Text(S.of(context).resetTraining),
            subtitle: Text(S.of(context).resetTrainingSubtitle),
            onTap: () => _resetTraining(context),
          ),
          ListTile(
            leading: const Icon(Icons.clear_all),
            title: Text(S.of(context).clearLocalData),
            subtitle: Text(S.of(context).clearLocalDataSubtitle),
            onTap: () => _clearLocal(context),
          ),
        ],
      ),
    );
  }
}
