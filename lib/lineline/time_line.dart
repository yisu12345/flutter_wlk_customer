import 'package:flutter/material.dart';

import 'dash_line.dart';

///@Desc 时间线
class TimeLine extends StatelessWidget {
  final bool isLast;
  final Widget child;

  const TimeLine({
    Key? key,
    required this.isLast,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _buildDot(),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff36C2FD),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        if (isLast)
          const SizedBox.shrink()
        else
          const Expanded(
            child: DashLine(
              color: Color(0xff36C2FD),
              direction: Axis.vertical,
            ),
          )
      ],
    );
  }
}
