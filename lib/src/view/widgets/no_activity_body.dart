import 'package:flutter/material.dart';
import 'package:lab_archive/utils/size_config.dart';

class NoActivityBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 6.03 * SizeConfig.heigthMultiplier,
        ),
        Center(
          child: Text(
            'No tienes actividades',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 4.59 * SizeConfig.textMultiplier,
                color: Color(0xFF0397AC),
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 9.65 * SizeConfig.heigthMultiplier,
        ),
        Image.asset(
          'assets/img/no_activity_img.png',
        ),
      ],
    );
  }
}
