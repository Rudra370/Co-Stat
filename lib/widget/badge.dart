import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  final Color color;
  final String path;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double size;

  const Badge(
      {this.color,
      this.path,
      this.top = 0,
      this.bottom = 0,
      this.left = 0,
      this.right = 0,
      this.size});
  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: EdgeInsets.only(
            top: widget.top,
            bottom: widget.bottom,
            left: widget.left,
            right: widget.right),
        duration: PieChart.defaultDuration,
        padding: EdgeInsets.all(110 * .06),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            widget.path,
            fit: BoxFit.fitWidth,
            width: 30,
            height: 30,
            repeat: ImageRepeat.noRepeat,
          ),
        ));
  }
}
