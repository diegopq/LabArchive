import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final List<double> stops;

  Circle(
      {@required this.radius,
      @required this.gradientColors,
      this.gradientBegin,
      this.gradientEnd,
      this.stops});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: gradientBegin,
          end: gradientEnd,
          stops: stops,
        ),
        borderRadius: BorderRadius.circular(this.radius),
      ),
    );
  }
}
