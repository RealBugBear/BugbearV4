import 'dart:math';
import 'package:flutter/material.dart';

class TimerRing extends StatelessWidget {
  /// The progress value between 0.0 (empty) and 1.0 (full).
  final double progress;
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const TimerRing({
    super.key,
    required this.progress,
    this.size = 100,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TimerRingPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _TimerRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define stroke width and calculate center and radius.
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw the background circle.
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw the progress arc.
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Calculate the sweep angle based on the progress value.
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from the top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever the progress value changes.
  }
}
