import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab_archive/src/model/api/crud_api.dart';
import 'package:lab_archive/src/view/widgets/circular_loading.dart';

import 'package:lab_archive/src/view/widgets/no_evidence_body.dart';
import 'package:lab_archive/utils/size_config.dart';

class EvidencePage extends StatefulWidget {
  static String namePage = 'EvidencePage';

  Map<String, dynamic> arguments;
  int assignatureId;
  String assignatureName;
  String activity;

  EvidencePage({this.arguments}) {
    assignatureId = arguments['assignatureId'];
    assignatureName = arguments['assignatureName'];
    activity = arguments['activity'];
    print(assignatureId);
    print(activity);
  }

  @override
  _EvidencePageState createState() => _EvidencePageState();
}

class _EvidencePageState extends State<EvidencePage> {
  static final bool isIOS = Platform.isIOS;
  File _photo;
  bool _isLoading = false;
  Size _size;
  double _width;
  double _height;
  CrudAPI _apiCrud = CrudAPI();
  List<dynamic> _listEvidence = [];
  bool _charginData = true;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _width = _size.width;
    _height = _size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButton: _floatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: AppBar(
            title: Text('Evidencias'),
            elevation: isIOS ? 0.0 : 4.0,
            backgroundColor: Color(0xFF82E6F4),
          ),
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
    print('activity: ${widget.activity}');
    print('courseId: ${widget.assignatureId}');
    if (_charginData) {
      return FutureBuilder(
        future: _apiCrud.getEvidence(
            courseId: widget.assignatureId, activity: widget.activity),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
              _listEvidence = snapshot.data;
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
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.data.isEmpty) {
                return SingleChildScrollView(
                  child: NoEvidenceBody(),
                );
              }
              break;
          }
          return null;
        },
      );
    } else {
      if (_listEvidence.isEmpty) {
        return SingleChildScrollView(
          child: NoEvidenceBody(),
        );
      } else {
        return ListView.builder(
          itemCount: _listEvidence.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text(_listEvidence[index].name),
                onTap: () {
                  //cambiar a la pagina para ver evidencias
                },
              ),
            );
          },
        );
      }
    }
  }

  Widget _floatingActionButton() {
    return SpeedDial(
      elevation: isIOS ? 0.0 : 4.0,
      curve: Curves.easeInOutBack,
      backgroundColor: Color(0xFF029EB4),
      overlayOpacity: 0.0,
      child: Icon(Icons.add),
      children: [
        SpeedDialChild(
          child: Icon(Icons.camera_alt),
          onTap: () {
            _pickPhoto(source: ImageSource.camera);
          },
          label: isIOS ? null : 'Cámara',
          backgroundColor: Color(0xFF82E6F4),
        ),
        SpeedDialChild(
          child: Icon(Icons.image),
          onTap: () {
            _pickPhoto(source: ImageSource.gallery);
          },
          label: isIOS ? null : 'Galería',
          backgroundColor: Color(0xFF82E6F4),
        ),
      ],
    );
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

  _pickPhoto({@required ImageSource source}) async {
    _photo = await ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 33.77 * SizeConfig.heigthMultiplier,
    );

    _showPhoto(_photo);
  }

  _showPhoto(File photo) {
    print(photo.absolute.path);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: double.infinity,
              height: 33.77 * SizeConfig.heigthMultiplier,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: Image(
                        image: AssetImage(
                          photo.path,
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    FlatButton(child: Text('Guardar'), onPressed: _savePhoto)
                  ],
                ),
              ),
            ),
          );
        });
  }

  _savePhoto() async {
    setState(() {
      _isLoading = true;
      _charginData = true;
    });
    Navigator.of(context).pop();
    final success = await _apiCrud.addEvidence(
      courseId: widget.assignatureName,
      activityName: widget.activity,
      photo: _photo,
    );
    if (success) {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
