import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/models/calendar_model.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/services/local_storage_service.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:bugbear_app/themes/app_theme.dart';
import 'package:bugbear_app/widgets/confirm_dialog.dart';
import 'package:bugbear_app/widgets/app_drawer.dart';
import 'package:bugbear_app/generated/l10n.dart';

class ProfileScreen extends StatelessWidget {
  final TrainingService trainingService;
  final LocalStorageService localStorage;
  final FirebaseAuth auth;

  ProfileScreen({
    Key? key,
    TrainingService? trainingService,
    LocalStorageService? localStorage,
    FirebaseAuth? auth,
  })  : trainingService = trainingService ?? TrainingService(),
        localStorage = localStorage ?? LocalStorageService(),
        auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  User? get currentUser => auth.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(S.of(context).profileTitle)),
        drawer: const AppDrawer(),
        body: Center(child: Text(S.of(context).userNotLoggedIn)),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CalendarModel(
        trainingService: trainingService,
        localStorage: localStorage,
      ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalendarModel>();

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).overallProgressTitle)),
      drawer: const AppDrawer(),
      body: TableCalendar(
        firstDay: DateTime.utc(2000),
        lastDay: DateTime.utc(2100),
        focusedDay: model.visibleMonth,
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarStyle: CalendarStyle(
          markerDecoration: BoxDecoration(
            color: programColors[allPrograms.indexWhere((p) => p.id == model.activeProgramId)],
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppColors.gold, width: 2),
            shape: BoxShape.circle,
          ),
        ),
        selectedDayPredicate: (d) => model.completedDates.contains(DateTime(d.year, d.month, d.day)),
        onDaySelected: (sel, foc) async {
          final txt = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(sel);
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => ConfirmDialog(
              title: 'Eintragen?',
              message: 'Möchtest Du das Tracking für $txt speichern?',
              confirmLabel: S.of(context).yes,
              cancelLabel: S.of(context).no,
            ),
          );
          if (ok == true) await model.toggleCompleted(sel);
        },
        onPageChanged: (np) => model.setVisibleMonth = np,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: S.of(context).selectPhase,
        child: const Icon(Icons.edit),
        onPressed: () => _showPhaseSelection(context),
      ),
    );
  }

  void _showPhaseSelection(BuildContext context) {
    final model = context.read<CalendarModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: allPrograms.map((prog) {
          final idx = allPrograms.indexOf(prog);
          final pct = (model.completedDates.length / prog.plannedSessions).clamp(0.0,1.0);
          return ListTile(
            leading: CircleAvatar(backgroundColor: programColors[idx], child: Text('${(pct*100).toInt()}%')),
            title: Text(prog.name),
            onTap: () async {
              await model.setActiveProgram(prog.id);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
