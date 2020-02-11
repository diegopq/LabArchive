import 'dart:io';

import 'package:flutter/material.dart';

import 'package:lab_archive/src/model/api/crud_api.dart';
import 'package:lab_archive/src/model/assignature_model.dart';
import 'package:lab_archive/src/view/pages/home_page.dart';
import 'package:lab_archive/src/view/widgets/list_item.dart';
import 'package:lab_archive/src/view/widgets/loading_indicator.dart';
import 'package:lab_archive/utils/dialogs.dart';
import 'package:lab_archive/utils/size_config.dart';

class SelectCoursePage extends StatefulWidget {
  static final String namePage = 'CreateSubjectPage';

  @override
  _SelectCoursePageState createState() => _SelectCoursePageState();
} //fin de la clase

class _SelectCoursePageState extends State<SelectCoursePage> {
  static final bool isIOS = Platform.isIOS;
  CrudAPI _apiCrud = CrudAPI();
  List<int> _listOfAddedAssignatures = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePage.namePage);
              },
            ),
            elevation: isIOS ? 0.0 : 4.0,
            backgroundColor: Color(0xFF82E6F4),
            title: Text(
              'Cursos Disponibles',
              style: TextStyle(
                  fontSize: 5.37 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white),
            ),
          ),
          floatingActionButton: _floatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: FutureBuilder<List<AssignatureModel>>(
            future: _apiCrud.getAssignatures(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItem(
                        title: snapshot.data[index].name,
                        subtitle: 'Clave UDA: ${snapshot.data[index].key}',
                        onTap: (value) {
                          print(snapshot.data[index].name);
                          print(value);
                          print(snapshot.data[index].id);
                          //cuando se selecciona un curso se agrega a la lista de materias por inscribir
                          //si se deselecciona se elimina de la lista
                          if (value) {
                            if (_listOfAddedAssignatures
                                .contains(snapshot.data[index].id)) {
                              //si el elemento ya esta en la lista
                              Alerts.errorAlertRegisterOrLogin(
                                  title: 'La materia ya se agrego');
                            } else {
                              _listOfAddedAssignatures
                                  .add(snapshot.data[index].id);
                              setState(() {});
                            }
                          } else {
                            //se elimina de la lista cuando se deselecciona
                            _listOfAddedAssignatures
                                .remove(snapshot.data[index].id);
                            setState(() {});
                          }
                          print(
                              'lista de materias a agregar: $_listOfAddedAssignatures');
                        },
                      );
                    },
                  ),
                );
              } else {
                return LoadingIndicatorCustom();
              }
            },
          ),
        ),
        loadingIndicator(),
      ],
    );
  }

  Future<bool> _addAssignatures() async {
    bool done;
    for (var item in _listOfAddedAssignatures) {
      print(item);
      done = await _apiCrud.addCourses(item);
    }
    return done;
  }

  Widget loadingIndicator({double width, double height}) {
    if (_isLoading) {
      return Container(
        color: Colors.black54.withOpacity(0.8),
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.teal[400],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF82E6F4)),
            strokeWidth: 2.0,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _floatingActionButton() {
    bool done;
    return FloatingActionButton.extended(
      label: Text('Agregar'),
      elevation: _listOfAddedAssignatures.isEmpty ? 0.0 : 4.0,
      backgroundColor:
          _listOfAddedAssignatures.isEmpty ? Colors.grey : Color(0xFF029EB4),
      onPressed: _listOfAddedAssignatures.isEmpty
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              done = await _addAssignatures();
              print('se agrego materia');
              setState(() {
                _isLoading = false;
              });
              if (done) {
                Alerts.onSuccess(title: 'Se agregaron las materias');
                Navigator.pushReplacementNamed(context, HomePage.namePage);
              }
            },
    );
  }
} //fin de state
