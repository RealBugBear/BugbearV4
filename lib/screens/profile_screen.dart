import 'package:flutter/material.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/models/training_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:bugbear_app/widgets/app_drawer.dart';
import 'package:bugbear_app/generated/l10n.dart';

class ProfileScreen extends StatelessWidget {
  // Injected dependencies
  final TrainingService trainingService;
  final FirebaseAuth auth;

  /// Accepts optional named parameters for easier testing
  ProfileScreen({
    Key? key,
    TrainingService? trainingService,
    FirebaseAuth? auth,
  })  : trainingService = trainingService ?? TrainingService(),
        auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  /// Derive currentUser from injected auth
  User? get currentUser => auth.currentUser;

  Widget buildMonthCalendar(
    BuildContext context,
    int year,
    int month,
    Set<String> trainingDays,
  ) {
    final DateTime firstDay = DateTime(year, month, 1);
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int startWeekday = firstDay.weekday;
    final int totalCells = startWeekday - 1 + daysInMonth;
    final int rows = (totalCells / 7).ceil();

    final List<TableRow> tableRows = [];
    final List<String> dayNames = [
      S.of(context).dayMo,
      S.of(context).dayDi,
      S.of(context).dayMi,
      S.of(context).dayDo,
      S.of(context).dayFr,
      S.of(context).daySa,
      S.of(context).daySo,
    ];

    tableRows.add(
      TableRow(
        children: dayNames
            .map(
              (name) => Center(
                child: Text(name, style: const TextStyle(fontSize: 10)),
              ),
            )
            .toList(),
      ),
    );

    int cellIndex = 0;
    for (int row = 0; row < rows; row++) {
      final List<Widget> cells = [];
      for (int col = 0; col < 7; col++) {
        cellIndex++;
        final int dayNum = cellIndex - (startWeekday - 1);
        if (dayNum < 1 || dayNum > daysInMonth) {
          cells.add(const SizedBox(height: 20, width: 20));
        } else {
          final DateTime currentDay = DateTime(year, month, dayNum);
          final String dateString = DateFormat('yyyy-MM-dd').format(currentDay);
          final bool completed = trainingDays.contains(dateString);
          cells.add(
            Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: completed ? Colors.green : Colors.grey.shade300,
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: Text(
                  '$dayNum',
                  style: TextStyle(
                    fontSize: 8,
                    color: completed ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }
      }
      tableRows.add(TableRow(children: cells));
    }

    return Column(
      children: [
        Text(
          DateFormat.MMMM(
            Localizations.localeOf(context).languageCode,
          ).format(firstDay),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: tableRows,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(S.of(context).profileTitle)),
        drawer: const AppDrawer(),
        body: Center(child: Text(S.of(context).userNotLoggedIn)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).overallProgressTitle)),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<TrainingSession>>(
          stream: trainingService.getAllTrainingSessions(
            userId: currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  S.of(context).errorLoading(snapshot.error.toString()),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final Set<String> trainingDays = snapshot.data!
                .map((session) => DateFormat('yyyy-MM-dd').format(session.sessionDate))
                .toSet();

            final int currentYear = DateTime.now().year;
            final List<Widget> monthWidgets = [];

            for (int month = 1; month <= 12; month++) {
              monthWidgets.add(
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: buildMonthCalendar(
                    context,
                    currentYear,
                    month,
                    trainingDays,
                  ),
                ),
              );
            }

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: monthWidgets,
            );
          },
        ),
      ),
    );
  }
}

