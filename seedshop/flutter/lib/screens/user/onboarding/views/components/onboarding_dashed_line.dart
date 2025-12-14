
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class OnBoardingDashedLine extends StatelessWidget{
  final double width;
  final double dashLength;
  final double dashGap;
  final Color color;
  final double strokeWidth;

  const OnBoardingDashedLine({
    super.key,
    required this.width,
    this.dashLength = 5.0,
    this.dashGap = 3.0,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, strokeWidth),
      painter: DashedLinePainter(
        dashLength: 9, // Length of each dash
        dashGap: 1.5, // Gap between each dash
        color: dashedLine, // Color of the dashed line
        strokeWidth: 0.5, // Thickness of the dashed line
      ),
     // child: Container(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double dashLength;
  final double dashGap;
  final Color color;
  final double strokeWidth;

  DashedLinePainter({
    this.dashLength = 5.0,
    this.dashGap = 3.0,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startX = 0;
    double y = size.height / 2;

    // Draw the dashed line
    while (startX < size.width) {
      // Draw the dash
      canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashLength, y),
          paint
      );

      // Move the starting point to the next dash, after the gap
      startX += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
