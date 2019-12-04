import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alerts {
  static void errorAlertRegister(BuildContext context,
      {String title = '', String message = '', VoidCallback onOk}) {
    //construimos la alerta
    Fluttertoast.showToast(
      msg: 'No se pudo registrar el usuario',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void errorObtainData(BuildContext context,
      {String title = '', String message = '', VoidCallback onOk}) {
    //construimos la alerta
    Fluttertoast.showToast(
      msg: 'Ha ocurrido un error',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
