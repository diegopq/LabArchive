import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_archive/utils/size_config.dart';

class Alerts {
  static void errorAlertRegisterOrLogin({
    String title = 'No se pudo registrar el usuario',
  }) {
    //construimos la alerta
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white,
      fontSize: 4.08 * SizeConfig.textMultiplier,
    );
  }

  static void errorObtainData({String title = 'Ha ocurrido un error'}) {
    //construimos la alerta
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white,
      fontSize: 4.08 * SizeConfig.textMultiplier,
    );
  }

  static void onSuccess({String title = 'Todo salio bien'}) {
    //construimos la alerta
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.green[800],
      textColor: Colors.white,
      fontSize: 4.08 * SizeConfig.textMultiplier,
    );
  }
}
