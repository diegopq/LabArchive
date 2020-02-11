import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lab_archive/src/model/activity_model.dart';
import 'package:lab_archive/src/model/added_assignature_list.dart';
import 'package:lab_archive/src/model/api/crud_api.dart';
import 'package:lab_archive/src/view/pages/evidence_page.dart';
import 'package:lab_archive/src/view/widgets/circular_loading.dart';
import 'package:lab_archive/src/view/widgets/no_activity_body.dart';
import 'package:lab_archive/utils/size_config.dart';

class ListActivitiesPage extends StatefulWidget {
  static String namePage = 'ListActivitiesPage';

  final AddedAssignatureModel assignature;

  ListActivitiesPage({this.assignature});
  @override
  _ListActivitiesPageState createState() => _ListActivitiesPageState();
}

class _ListActivitiesPageState extends State<ListActivitiesPage> {
  static final bool isIOS = Platform.isIOS;
  GlobalKey<FormState> _formActivity = GlobalKey();
  CrudAPI _apiCrud = CrudAPI();
  String _nameActivity;
  bool _isLoading = false;
  bool _charginData = true;
  Size _size;
  double _width;
  double _height;
  List<ActivityModel> _listActivities = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.assignature.name);
    print(widget.assignature.courseId);
    print(widget.assignature.assignatureId);
    _size = MediaQuery.of(context).size;
    _width = _size.width;
    _height = _size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: isIOS ? 0.0 : 4.0,
            title: Text(widget.assignature.name),
            backgroundColor: Color(0xFF82E6F4),
          ),
          floatingActionButton: _floatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 4.08 * SizeConfig.widthMultiplier),
            child: _body(),
          ),
        ),
        _loadingIndicator(),
      ],
    );
  }

  _body() {
    if (_charginData) {
      return FutureBuilder(
        future:
            _apiCrud.getActivities(courseId: widget.assignature.assignatureId),
        builder: (BuildContext context,
            AsyncSnapshot<List<ActivityModel>> snapshot) {
          //si hay un error en el snapshot
          if (snapshot.hasError) {
            print('snapshot error: ${snapshot.error}');
            return Container(
              width: _width,
              height: _height - (24.12 * SizeConfig.heigthMultiplier),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Ocurrió un error con el snapshot'),
                  FlatButton(
                    child: Text(
                      'Reintentar',
                      style: TextStyle(
                          fontSize: 4.59 * SizeConfig.textMultiplier,
                          color: Colors.teal[800]),
                    ),
                    onPressed: () {
                      //charginData = true;
                      //isLoading = true;
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print('estado none');
              return Container(
                height: _height - (24.12 * SizeConfig.heigthMultiplier),
                width: _width,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ocurrió un error'),
                    FlatButton(
                      child: Text(
                        'Reintentar',
                        style: TextStyle(
                            fontSize: 4.59 * SizeConfig.textMultiplier,
                            color: Colors.teal[800]),
                      ),
                      onPressed: () {
                        //charginData = true;
                        //isLoading = true;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
              break;
            case ConnectionState.waiting:
              //esperando los datos
              print('estado esperando');
              return Container(
                width: _width,
                height: _height - (24.12 * SizeConfig.heigthMultiplier),
                child: CircularLoading(),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              _listActivities = snapshot.data;
              _charginData = false;
              //cuando obtuvo la data
              print('estado done');
              if (snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data[index].name),
                        onTap: () {
                          //cambiar a la pagina para ver evidencias
                          Navigator.pushNamed(context, EvidencePage.namePage,
                              arguments: {
                                'assignatureId': widget.assignature.courseId,
                                'assignatureName': widget.assignature.name,
                                'activity': _listActivities[index].name
                              });
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.data.isEmpty) {
                return SingleChildScrollView(
                  child: NoActivityBody(),
                );
              }
              break;
          }
          return null;
        },
      );
    } else {
      if (_listActivities.isEmpty) {
        return SingleChildScrollView(
          child: NoActivityBody(),
        );
      } else {
        return ListView.builder(
          itemCount: _listActivities.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text(_listActivities[index].name),
                onTap: () {
                  //cambiar a la pagina para ver evidencias
                  Navigator.pushNamed(
                    context,
                    EvidencePage.namePage,
                    arguments: {
                      'assignatureId': widget.assignature.courseId,
                      'assignatureName': widget.assignature.name,
                      'activity': _listActivities[index].name
                    },
                  );
                },
              ),
            );
          },
        );
      }
    }
  }

  Widget _floatingActionButton() {
    return FloatingActionButton.extended(
      label: Container(
        width: 38.26 * SizeConfig.widthMultiplier,
        child: Text(
          'Crear actividad',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 4.59 * SizeConfig.textMultiplier),
        ),
      ),
      backgroundColor: Color(0xFF029EB4),
      onPressed: () {
        // Navigator.pushNamed(context, CreateActivityPage.namePage);
        showCustomDialog();
        //Navigator.pushNamed(context, EvidencePage.namePage);
      },
    );
  }

  Future<bool> showCustomDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(2.55 * SizeConfig.widthMultiplier),
            width: double.infinity,
            height: 25.33 * SizeConfig.heigthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Nueva actividad',
                  style: TextStyle(
                    fontSize: 4.59 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0397AC),
                  ),
                ),
                SizedBox(
                  height: 3.01 * SizeConfig.heigthMultiplier,
                ),
                Form(
                  key: _formActivity,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      helperText: 'Escribe el nombre de la nueva actividad',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Color(0xFF0397AC),
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        gapPadding: 2.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Color(0xFF0397AC),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gapPadding: 2.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(20.0),
                          gapPadding: 2.0),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 1.80 * SizeConfig.heigthMultiplier,
                          horizontal: 2.55 * SizeConfig.widthMultiplier),
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: Color(0xFF0397AC),
                      ),
                    ),
                    validator: (value) {
                      if (value == '' || value.isEmpty) {
                        return 'Escribe el nombre de la actividad';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nameActivity = value;
                    },
                    cursorColor: Color(0xFF82E6F4),
                  ),
                ),
                SizedBox(
                  height: 1.80 * SizeConfig.heigthMultiplier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      onPressed: () {
                        setState(() {
                          _charginData = true;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Crear',
                        style: TextStyle(
                          color: Color(0xFF0397AC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _saveActivity,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _saveActivity() async {
    bool saveData;
    if (_formActivity.currentState.validate()) {
      _formActivity.currentState.save();
      print(_nameActivity);
      //hacer post a la api con los datos solicitados
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
      saveData = await _apiCrud.addActivity(
          courseId: widget.assignature.assignatureId,
          activityName: _nameActivity);
      if (saveData) {
        //Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
          _charginData = true;
        });
        //Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
          _charginData = true;
        });
      }
    }
  }

  Widget _loadingIndicator() {
    if (_isLoading) {
      return Container(
        color: Colors.black54.withOpacity(0.8),
        width: _width,
        height: _height,
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
}
