import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab_archive/src/model/user_model.dart';
import 'package:lab_archive/utils/dialogs.dart';
import 'package:lab_archive/utils/session.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'package:lab_archive/utils/app_config.dart';

class AuthAPI {
  final _session = Session();

  //registro
  Future<bool> register({UserModel userData}) async {
    final url = '${AppConfig.apiHost}/labarchive/signup';

    //post, en headers se le puede pasar el api key, en el body los datos del usuario
    try {
      final response = await http.post(
        url,
        body: {
          'nue': userData.nue,
          'nombre': userData.name,
          'apellido': userData.lastName,
          'correo': userData.email,
          'contrasena': userData.password,
        },
      );

      //de acuerdo a la respuesta devuelta por la api se valida
      if (response.statusCode == 200) {
        //la respuesta del servidor esta como un string por lo que la
        //convertimos a un objeto
        final parsed = json.decode(response.body);
        // print('todo salio bien');
        // print('response 200: ${response.body}');
        final token = parsed['token'] as String;
        print(token);
        //guardamos el token
        await _session.saveToken(
          token,
        );
        return true;
      } else if (response.statusCode == 500) {
        //lanzamos una excepcion
        throw PlatformException(code: '500', message: response.body);
      }
    } on PlatformException catch (e) {
      //lanzamos una excepcion personalizada
      print('Error ${e.code}: ${e.message}');
      Alerts.errorAlertRegisterOrLogin(title: e.message);
      return false;
    }
  }

  //login
  Future<bool> login(
      {@required String email, @required String password}) async {
    final url = '${AppConfig.apiHost}/labarchive/login';

    try {
      final response =
          await http.post(url, body: {'correo': email, 'contrasena': password});

      print('status login: ${response.statusCode}');
      // print(response.body);

      //en caso de que se haya realizado el login de manera correcta
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        // print('response 200: ${response.headers}');
        // print('response 200: ${response.body}');
        final token = parsed['token'] as String;

        //guardamos el token de manera segura
        await _session.saveToken(token);
        //si todo salio bien
        return true;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: '500', message: response.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(
            code: '503', message: 'Ocurrio un error al iniciar sesion');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Alerts.errorAlertRegisterOrLogin(title: e.message);
      return false;
    }
  }

//cerrar sesion
  Future<void> signOut() async {
    await _session.deleteToken();
    print(await _session.getToken());
  }
}
