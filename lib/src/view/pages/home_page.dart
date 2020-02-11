import 'dart:io';

import 'package:flutter/material.dart';

import 'package:lab_archive/src/model/added_assignature_list.dart';
import 'package:lab_archive/src/model/api/auth_api.dart';
import 'package:lab_archive/src/model/api/crud_api.dart';
import 'package:lab_archive/src/view/pages/list_activities_page.dart';
import 'package:lab_archive/src/view/pages/login_page.dart';
import 'package:lab_archive/src/view/pages/select_course_page.dart';
import 'package:lab_archive/src/view/widgets/circular_loading.dart';
import 'package:lab_archive/src/view/widgets/menu.dart';
import 'package:lab_archive/src/view/widgets/no_class_body.dart';
import 'package:lab_archive/utils/size_config.dart';

class HomePage extends StatefulWidget {
  static final String namePage = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final bool isIOS = Platform.isIOS;

  bool isCollapsed = true;
  bool isLoading = true;
  bool charginData = true;

  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);
  AuthAPI _auth = AuthAPI();
  CrudAPI _apiCrud = CrudAPI();
  List<AddedAssignatureModel> _listAssignatures;
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    //obtainData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          menu(),
          dashboard(),
        ],
      ),
    );
  }

  Widget menu() {
    return SlideTransition(
      position: _slideAnimation,
      child: Menu(
        onSignOut: _signOut,
      ),
    );
  }

  Widget dashboard() {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.5 * screenWidth,
      right: isCollapsed ? 0 : -0.3 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            if (!isCollapsed) {
              setState(() {
                isCollapsed = true;
                _controller.reverse();
              });
            }
          },
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              floatingActionButton: _floatingButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: isIOS ? 0.0 : 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                backgroundColor: Color(0xFF82E6F4),
                leading: IconButton(
                  icon: Icon(
                    IconData(0xe900, fontFamily: 'MenuIcon'),
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () {
                    if (_listAssignatures != null) {
                      charginData = false;
                      setState(() {
                        if (isCollapsed) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                        isCollapsed = !isCollapsed;
                      });
                    }
                  },
                ),
                title: Text(
                  'DashBoard',
                  style: TextStyle(
                      fontSize: 5.37 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white),
                ),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 4.08 * SizeConfig.widthMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: _changeBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

//floating button
  Widget _floatingButton() {
    return FloatingActionButton.extended(
        label: Container(
          width: 38.26 * SizeConfig.widthMultiplier,
          child: Text(
            'Agregar curso',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 4.59 * SizeConfig.textMultiplier),
          ),
        ),
        backgroundColor: Color(0xFF029EB4),
        onPressed: () {
          Navigator.pushReplacementNamed(context, SelectCoursePage.namePage);
        });
  }

  // metodo que cambia el body
  Widget _changeBody() {
    return charginData
        ? FutureBuilder<List<AddedAssignatureModel>>(
            future: _apiCrud
                .getAddedAssignatures(), //_apiCrud.getAddedAssignatures(),
            builder: (BuildContext context,
                AsyncSnapshot<List<AddedAssignatureModel>> snapshot) {
              //print(snapshot.data);
              if (snapshot.hasError) {
                return Center(
                  child: Column(
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
                          charginData = true;
                          //isLoading = true;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              }
              //diferentes casos
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print('estado none');
                  return Center(
                    child: Column(
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
                            charginData = true;
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
                  return CircularLoading();
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  //cuando obtuvo la data
                  print('estado done');
                  if (snapshot.data.isNotEmpty) {
                    _listAssignatures = snapshot.data;
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        charginData = false;
                        //isLoading = false;
                        return Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            title: Text(snapshot.data[index].name),
                            onTap: () {
                              //cambiar a la pagina para crear actividades
                              Navigator.pushNamed(
                                  context, ListActivitiesPage.namePage,
                                  arguments: snapshot.data[index]);
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.data.isEmpty) {
                    return NoClassBody();
                  }
                  break;
              }
              return null;
            },
          )
        : (_listAssignatures.isEmpty)
            ? NoClassBody()
            : ListView.builder(
                itemCount:
                    _listAssignatures.isEmpty ? 0 : _listAssignatures.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text(_listAssignatures[index].name),
                      onTap: () {
                        //cambiar a la pagina para crear actividades
                        Navigator.pushNamed(
                            context, ListActivitiesPage.namePage,
                            arguments: _listAssignatures[index]);
                      },
                    ),
                  );
                },
              );
  }

  // obtainData() async {
  //   _listAssignatures = await _apiCrud.getAddedAssignatures();
  // }

  //funcion para cerrar sesion
  Future<void> _signOut() async {
    print('cerrar sesion');
    setState(() {
      isCollapsed = true;
      _controller.reverse();
    });
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, LoginPage.namePage);
  }
} //fin de la clase
