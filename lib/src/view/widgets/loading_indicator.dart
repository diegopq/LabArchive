import 'package:flutter/material.dart';

class LoadingIndicatorCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      //strokeWidth: 2.0,
      backgroundColor: Colors.teal[400],
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF82E6F4)),
    );
  }
}
