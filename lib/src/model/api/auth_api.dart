import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'package:lab_archive/utils/app_config.dart';

class AuthAPI {
  //registro
  register(String userName, String email, String password) async {
    final url = '${AppConfig.apiHost}/register';

    //post, en headers se le puede pasar el api key, en el body los datos del usuario
    try {
      final response = await http.post(
        url,
        headers: {
          'apikey': 'osossloekskal',
        },
        body: {'name': userName, 'email': email, 'pass': password},
      );

      //la respuesta del servidor esta como un string por lo que la
      //convertimos a un objeto
      final parsed = json.decode(response.body);

      //de acuerdo a la respuesta devuelta por la api se valida
      if (response.statusCode == 200) {
        print('todo salio bien');
        //hacemos lo que se ocupe con los datos ya paseados, video clase 5 min 12
        //guardamos el token
      } else if (response.statusCode == 500) {
        //lanzamos una excepcion
        throw PlatformException(code: '500', message: parsed['message']);
      }
    } on PlatformException catch (e) {
      //lanzamos una excepcion personalizada
      print('Error: ${e.message}');
    }
  }
}
