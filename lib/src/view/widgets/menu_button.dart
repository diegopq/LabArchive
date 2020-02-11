import 'package:flutter/material.dart';
import 'package:lab_archive/utils/size_config.dart';

class MenuButton extends StatelessWidget {
  final double screenWidth;
  final String title;
  final Function onPress;

  MenuButton({this.screenWidth, this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            textColor: Colors.teal[800],
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 5.10 * SizeConfig.widthMultiplier),
            ),
            onPressed: onPress,
          ),
          Container(
            width: screenWidth / 1.7,
            child: Divider(),
          ),
          SizedBox(
            height: 1.42 * SizeConfig.heigthMultiplier,
          ),
        ],
      ),
    );
  }
}
