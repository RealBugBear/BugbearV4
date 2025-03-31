import 'package:flutter/material.dart';
import 'package:bugbear_app/widgets/custom_button.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Moro',
              onPressed: () {
                Navigator.pushNamed(context, '/moro');
              },
            ),
            const SizedBox(width: 20),
            CustomButton(
              text: 'Spinalergalant',
              onPressed: () {
                Navigator.pushNamed(context, '/spinalergalant');
              },
            ),
          ],
        ),
      ),
    );
  }
}
