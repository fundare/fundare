import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  double carAltitude;
  double currentAltitude; // user's
  double originalAltitude; // user's

  MyPainter(double carAlti, double currAlti, double originalAlti) {
    this.carAltitude = carAlti;
    this.currentAltitude = currAlti;
    this.originalAltitude = originalAlti;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); // style to use when drawing on a Canvas.
    paint.color = Colors.black;
    paint.strokeWidth = 2;

    double fromTop = 0;
    double fromBottom = 0;
    final p1 = Offset(size.width / 2.0, fromTop); // z-axis line, top point
    final p2 =
        Offset(size.width / 2.0, size.height - fromBottom); // bottom point
    canvas.drawLine(p1, p2, paint);

    final path = Path(); // arrow for z-axis
    path.moveTo(size.width / 2.0 - 5.0, 20.0); // z-axis arrow, left point
    path.lineTo(p1.dx, p1.dy - 2.0);
    path.lineTo(size.width / 2.0 + 5.0, 20.0); // right point
    path.close();
    canvas.drawPath(path, paint);

    paint.style = PaintingStyle.fill;
    paint.color = Colors.red;
    canvas.drawCircle(
        Offset(p1.dx, size.height / 2.0), 6, paint); // plot car altitude

    paint.color = Colors.blue;
    double halfAxisLength = (carAltitude - originalAltitude).abs() * 1.5;
    double currAltiPosition =
        (carAltitude - currentAltitude) / halfAxisLength * size.height / 2.0 +
            size.height / 2.0;
    canvas.drawCircle(Offset(p1.dx, currAltiPosition), 4,
        paint); // plot user current altitude
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    bool repaintBool =
        (oldDelegate.currentAltitude - currentAltitude).abs() > 0.5;
    return repaintBool;
  }
}
