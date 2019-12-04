import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_archive/src/model/assignature_model.dart';
import 'package:lab_archive/utils/app_config.dart';

class CrudAPI {
  Future<List<AssignatureModel>> getAssignatures() async {
    final String _url = '${AppConfig.apiHost}/labarchive/materias/';
    List<AssignatureModel> _listAssignatures = [];

    try {
      final response = await http.get(_url);
      print(response.statusCode);
      final responseData = jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        //si se realizo la peticion correctamente se recibe un codigo 200, por lo que hacemos el for
        //recorremos todo el json y creamos un objeto de AssignatureModel, cada objeto se agregara a una lista
        //de objetos del mismo tipo que es lo que se va a regresar
        for (var item in responseData) {
          AssignatureModel assignature = AssignatureModel(
              id: item['materia_id'], key: item['clave'], name: item['nombre']);
          _listAssignatures.add(assignature);
        }
        print(_listAssignatures);
        return _listAssignatures;
      } else {
        print('La respuesta no fue 200');
      }
    } catch (e) {
      print('Error: $e');
    }
    return _listAssignatures;
  }
}
