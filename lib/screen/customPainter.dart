import 'dart:math' as math;
import 'package:flutter/material.dart';

class WeatherPainter extends CustomPainter {
  final List<double> temperatures;
  final List<String> labels;

  WeatherPainter({required this.temperatures, required this.labels});
  @override
  void paint(Canvas canvas, Size size) {
    print('--RAW--TEMPERATURES-- $temperatures');
    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final double maxTemp = temperatures.reduce(math.max);
    final double minTemp = temperatures.reduce(math.min);
    final double tempRange = (maxTemp - minTemp).abs() < 1
        ? 10
        : (maxTemp - minTemp);

    final double padding = 20.0;
    final double chartHeight = size.height;
    final double chartWidth = size.width;
      final double barGap = chartWidth / temperatures.length;
    final double barWidth = barGap * 0.6;

    List<Offset> points = [];

    for (int i = 0; i < temperatures.length; i++) {
      final double temp = temperatures[i];

      final double normalizedHeight =
          ((temp - minTemp + 5) / (tempRange + 10)) * chartHeight; // normalize height calculation ?

      final double x = (i * barGap) + (barGap / 2);
      final double y = size.height - padding - normalizedHeight; //  position y calculation ?

      canvas.drawRect(
        Rect.fromLTWH(x - (barWidth / 2), y, barWidth, normalizedHeight), // x - (barWidth / 2)
        barPaint,
      );

      points.add(Offset(x, y));

      final textPainter = TextPainter(
        text: TextSpan(text: "${temp.toStringAsFixed(1)}°C", style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - (textPainter.width / 2), y - textPainter.height - 5),
      );


      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: textStyle.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();   // ..layout() ?

      labelPainter.paint(
        canvas,
        Offset(x - (labelPainter.width /2), size.height - labelPainter.height), // this calculation too ?
      );
    }

    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant WeatherPainter oldDelegate) =>
      oldDelegate.temperatures != temperatures || oldDelegate.labels != labels;
}
