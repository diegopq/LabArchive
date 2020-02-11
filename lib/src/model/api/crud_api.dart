import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:lab_archive/src/model/activity_model.dart';
import 'package:lab_archive/src/model/added_assignature_list.dart';
import 'package:lab_archive/src/model/assignature_model.dart';
import 'package:lab_archive/utils/app_config.dart';
import 'package:lab_archive/utils/dialogs.dart';
import 'package:lab_archive/utils/session.dart';

class CrudAPI {
  final _session = Session();
//================== metodos get ===============================

//verifica que el servidor este activo
  _isActive() async {
    final response = await http.get('${AppConfig.apiHost}/');
    print('servidor activo: ${response.statusCode}');
  }

  //metodo para obtener las materias disponibles
  Future<List<AssignatureModel>> getAssignatures() async {
    final String _url = '${AppConfig.apiHost}/labarchive/materias/';
    List<AssignatureModel> _listAssignatures = List();
    try {
      final response = await http.get(_url);
      print('status cursos disponibles: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        //si se realizo la peticion correctamente se recibe un codigo 200, por lo que hacemos el for
        //recorremos todo el json y creamos un objeto de AssignatureModel, cada objeto se agregara a una lista
        //de objetos del mismo tipo que es lo que se va a regresar
        for (var item in responseData) {
          AssignatureModel assignature = AssignatureModel(
              id: item['materia_id'], key: item['clave'], name: item['nombre']);
          _listAssignatures.add(assignature);
        }
        _listAssignatures.sort((AssignatureModel a, AssignatureModel b) =>
            a.name.compareTo(b.name));
        return _listAssignatures;
      } else {
        print('La respuesta no fue 200');
      }
    } catch (e) {
      print('Error: $e');
      Alerts.errorObtainData();
    }
    return _listAssignatures;
  }

  //metodo para obtener las materias suscritas
  Future<List<AddedAssignatureModel>> getAddedAssignatures() async {
    //url de la api
    final String _url = '${AppConfig.apiHost}/labarchive/cursos_materias/';
    List<AddedAssignatureModel> _listAssignatures = List();
    try {
      final token = await _session.getToken();
      //print(token['token']);
      final response = await http.get(
        _url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token['token']}'},
      );

      print('status added assignatures: ${response.statusCode}');

      if (response.statusCode == 200) {
        //si se realizo la peticion correctamente se recibe un codigo 200, por lo que hacemos el for
        //recorremos todo el json y creamos un objeto de CourseModel, cada objeto se agregara a una lista
        //de objetos del mismo tipo que es lo que se va a regresar
        //print(response.body);
        final List<dynamic> responseData = jsonDecode(response.body);
        for (var item in responseData) {
          AddedAssignatureModel assignature = AddedAssignatureModel(
              courseId: item['curso_id'],
              assignatureId: item['materia_id'],
              name: item['materia']);
          _listAssignatures.add(assignature);
        }
        //ordena la lista alfabeticamente
        _listAssignatures.sort(
            (AddedAssignatureModel a, AddedAssignatureModel b) =>
                a.name.compareTo(b.name));
        return _listAssignatures;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: '500', message: 'no hay materias aun');
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      // Alerts.errorObtainData(title: e.message);
      // _listAssignatures = [];
      return _listAssignatures;
    }
    return _listAssignatures;
  }

//obtener las actividades que tiene el curso seleccionado
  Future<List<ActivityModel>> getActivities({int courseId}) async {
    final String _url =
        '${AppConfig.apiHost}/labarchive/actividades/curso/$courseId';
    List<ActivityModel> _listActivities = List();

    try {
      final token = await _session.getToken();
      final response = await http.get(
        _url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token['token']}'},
      );

      print('status getActivities: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        for (var item in responseData) {
          ActivityModel activity = ActivityModel(
              courseId: item['curso_id'], name: item['descripcion']);
          _listActivities.add(activity);
        }
        //ordena la lista alfabeticamente
        _listActivities.sort(
            (ActivityModel a, ActivityModel b) => a.name.compareTo(b.name));
        return _listActivities;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: '500', message: response.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      return _listActivities;
    }
    return _listActivities;
  }

  //obtiene las evidencias
  Future<dynamic> getEvidence({int courseId, String activity}) async {
    final String _url =
        '${AppConfig.apiHost}/labarchive/evidencias/$courseId/$activity';
    List<dynamic> _listEvidence = List();

    try {
      final token = await _session.getToken();
      final response = await http.get(
        _url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token['token']}'},
      );

      print('status getEvidence: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        for (var item in responseData) {
          ActivityModel activity = ActivityModel(
              courseId: item['curso_id'], name: item['descripcion']);
          _listEvidence.add(activity);
        }
        //ordena la lista alfabeticamente
        _listEvidence.sort((dynamic a, dynamic b) => a.name.compareTo(b.name));
        return _listEvidence;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: '500', message: response.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Alerts.errorObtainData(title: e.message);
      return _listEvidence;
    }
    return _listEvidence;
  }

  //================== metodos post ===============================

//metodo para agregar materias
  Future<bool> addCourses(int courseId) async {
    final url = '${AppConfig.apiHost}/labarchive/curso/add/';

    try {
      final token = await _session.getToken();

      await _isActive();

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${token['token']}',
        },
        body: jsonEncode({'materia_id': courseId}),
      );

      if (response.statusCode == 200) {
        //si se agrego correctamente
        final parsed = json.decode(response.body);
        print(parsed['mensaje']);
        print(parsed['materia']);
        print(parsed['periodo']);
        return true;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: '500', message: response.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Alerts.errorObtainData(title: e.message);
      return false;
    }
    return false;
  }

  //metodo para agregar actividades a una materia
  Future<bool> addActivity({int courseId, String activityName}) async {
    final url = '${AppConfig.apiHost}/labarchive/actividades/';

    try {
      final token = await _session.getToken();

      await _isActive();

      //http method
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${token['token']}',
        },
        body: jsonEncode({'descripcion': activityName, 'materia_id': courseId}),
      );

      print('status addActivity: ${response.statusCode}');
      if (response.statusCode == 200) {
        //si se agrego correctamente
        final parsed = json.decode(response.body);
        print(parsed['mensaje']);
        print(parsed['materia']);
        print(parsed['descripcion']);

        Alerts.onSuccess(title: 'Se agregó la actividad');
        return true;
      } else if (response.statusCode == 500) {
        //cuando hay error
        throw PlatformException(code: '500', message: response.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Alerts.errorObtainData(title: e.message);
      return false;
    }
    return false;
  }

//metodo para agregar la evidencia
  Future<bool> addEvidence(
      {String courseId, String activityName, File photo}) async {
    final url = Uri.parse(
        '${AppConfig.apiHost}/labarchive/upload/AGO-DIC 2019/$courseId/$activityName');

    final mimeType = mime(photo.path).split('/');

    try {
      final token = await _session.getToken();

      await _isActive();

      //http method
      final request = http.MultipartRequest('POST', url);

      final file = await http.MultipartFile.fromPath('file', photo.path,
          contentType: MediaType(
            mimeType[0],
            mimeType[1],
          ));
      request.fields['token'] = token['token'].toString();
      request.files.add(file);

      final response = await request.send();

      final resp = await http.Response.fromStream(response);

      print('status addEvidence: ${response.statusCode}');
      if (resp.statusCode == 200) {
        //si se agrego correctamente
        final parsed = json.decode(resp.body);
        print('path: ${parsed['path']}');
        print('name: ${parsed['filename']}');
        Alerts.onSuccess(title: 'Guardado exitoso');
        return true;
      } else if (response.statusCode == 500) {
        //cuando hay error
        throw PlatformException(code: '500', message: resp.body);
      } else if (response.statusCode == 503) {
        throw PlatformException(code: '503', message: 'Error con la API');
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Alerts.errorObtainData(title: e.message);
      return false;
    }
    return false;
  }
}
