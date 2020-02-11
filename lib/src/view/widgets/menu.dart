import 'package:flutter/material.dart';
import 'package:lab_archive/src/view/widgets/menu_button.dart';
import 'package:lab_archive/utils/conts.dart';
import 'package:lab_archive/utils/size_config.dart';

class Menu extends StatelessWidget {
  double screenWidth, screenHeight;
  Size size;

  final Function onSignOut;

  Menu({this.onSignOut});

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: screenWidth / 1.7,
        padding: EdgeInsets.only(
            left: 5.10 * SizeConfig.widthMultiplier,
            right: 5.10 * SizeConfig.widthMultiplier),
        //color: Colors.red,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5.42 * SizeConfig.heigthMultiplier,
              ),
              Center(
                child: Image.asset(
                  'assets/img/logo_login.png',
                  width: 38.26 * SizeConfig.widthMultiplier,
                ),
              ),
              SizedBox(
                height: 5.42 * SizeConfig.heigthMultiplier,
              ),
              SizedBox(
                height: 8.42 * SizeConfig.heigthMultiplier,
              ),
              FlatButton.icon(
                icon: Icon(Icons.power_settings_new),
                label: Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 4.30 * SizeConfig.widthMultiplier),
                ),
                textColor: Colors.red,
                onPressed: onSignOut,
              )
            ],
          ),
        ),
      ),
    );
  }
}
