import 'dart:math' as math;
import 'package:flutter/material.dart';

class TestPainter extends CustomPainter {
  final List<double> temperatures;
  final List<String> labels;
  final double animationValue;
  final List<Color> barColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
  ];

  TestPainter({
    required this.temperatures,
    required this.labels,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatures.isEmpty) return;

    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.purple, Colors.pink],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final double maxTemp = temperatures.reduce(math.max);
    final double minTemp = temperatures.reduce(math.min);
    final double tempRange =
    (maxTemp - minTemp).abs() < 1 ? 10 : (maxTemp - minTemp);

    final double chartHeight = size.height;
    final double chartWidth = size.width;
    final double barGap = chartWidth / temperatures.length;
    final double barWidth = barGap * 0.6;

    List<Offset> points = [];

    for (int i = 0; i < temperatures.length; i++) {
      final double temp = temperatures[i];
      final double normalizedHeight =
          ((temp - minTemp + 5) / (tempRange + 16)) * chartHeight;

      final double animatedHeight = normalizedHeight * animationValue;

      final double x = (i * barGap) + (barGap / 2);
      final double y = size.height - animatedHeight;

      final barPaint = Paint()
        ..color = barColors[i]
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x - (barWidth / 2), y, barWidth, animatedHeight),
        barPaint,
      );

      points.add(Offset(x, y * 0.72));


      if (animationValue > 0.7) {
        final double textOpacity =
        ((animationValue - 0.7) / 0.3).clamp(0.0, 1.0);

        final textPainter = TextPainter(
          text: TextSpan(
            text: "${temp.toStringAsFixed(1)}°C",
            style: textStyle.copyWith(
              color: Colors.black.withOpacity(textOpacity),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final labelPainter = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: textStyle.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.black.withOpacity(textOpacity),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        labelPainter.paint(
          canvas,
          Offset(x - (labelPainter.width / 2), size.height),
        );
        textPainter.paint(
          canvas,
          Offset(x - (textPainter.width / 2), y - textPainter.height - 5),
        );
      }
    }

    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final current = points[i];
        final next = points[i + 1];
        final controlX = (current.dx + next.dx) / 2;
        path.cubicTo(
          controlX, current.dy,
          controlX, next.dy,
          next.dx, next.dy,
        );
      }

      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant TestPainter oldDelegate) =>
      oldDelegate.temperatures != temperatures ||
          oldDelegate.labels != labels ||
          oldDelegate.animationValue != oldDelegate.animationValue;
}