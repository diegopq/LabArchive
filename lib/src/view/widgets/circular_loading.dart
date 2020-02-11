import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  Size _size;
  double _width;
  double _height;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _width = _size.width;
    _height = _size.height;

    return Container(
      //color: Colors.black54.withOpacity(0.8),
      // width: _width,
      // height: _height,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.teal[400],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF82E6F4)),
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
