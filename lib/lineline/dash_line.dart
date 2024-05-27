import 'package:flutter/material.dart';

///@Desc 虚线
class DashLine extends StatelessWidget {
  final Color? color; // 虚线颜色
  final Axis direction; // 虚线方向

  const DashLine({
    Key? key,
    this.color,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(
        color: color ?? const Color(0xff36C2FD),
        direction: direction,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double width;
  final Axis direction; //方向

  DashedLinePainter({
    this.width = 1,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    Path dottedPath = _createDashedPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(
          direction == Axis.horizontal ? size.width : 0,
          direction == Axis.horizontal ? 0 : size.height,
        ),
    );
    canvas.drawPath(dottedPath, paint);
  }

  Path _createDashedPath(Path path) {
    Path targetPath = Path();
    double dottedLength = 10;
    double dottedGap = 10;
    for (var metric in path.computeMetrics()) {
      double distance = 0;
      bool isDrawDotted = true;
      while (distance < metric.length) {
        if (isDrawDotted) {
          targetPath.addPath(
            metric.extractPath(distance, distance + dottedLength),
            Offset.zero,
          );
          distance += dottedLength;
        } else {
          distance += dottedGap;
        }
        isDrawDotted = !isDrawDotted;
      }
    }
    return targetPath;
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}
