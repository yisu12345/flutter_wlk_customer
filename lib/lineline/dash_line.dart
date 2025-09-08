import 'package:flutter/material.dart';

///@Desc 虚线
class DashLine extends StatelessWidget {
  final Color? color; // 虚线颜色
  final Axis direction; // 虚线方向
  final double? dottedLength; //虚线长度

  const DashLine({
    Key? key,
    this.color,
    this.direction = Axis.horizontal,
    this.dottedLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(
        color: color ?? const Color(0xff36C2FD),
        direction: direction,
        dottedLength: dottedLength,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double width;
  final Axis direction; //方向
  final double? dottedLength; //虚线长度

  DashedLinePainter({
    this.width = 1,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
    this.dottedLength,
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
      length: dottedLength,
    );
    canvas.drawPath(dottedPath, paint);
  }

  Path _createDashedPath(Path path,{double? length}) {
    Path targetPath = Path();
    double dottedLength = length ?? 10;
    double dottedGap = length ?? 10;
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
