import 'package:flutter/material.dart';
import 'package:lab_archive/src/view/widgets/circle.dart';
import 'package:lab_archive/src/view/widgets/text_field_custom.dart';
import 'package:lab_archive/utils/conts.dart';
import 'package:lab_archive/utils/size_config.dart';

class LoginPage extends StatefulWidget {
  static final String namePage = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Size _size;
  double _width;
  double _height;
  String _user;
  String _password;
  FocusNode focusPass;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    focusPass = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    focusPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _width = _size.width;
    _height = _size.height;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF30B0F4),
                Color(0xFF04398E),
              ],
              stops: <double>[0.0, 0.85],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: -10.61 * SizeConfig.widthMultiplier,
                top: -3.20 * SizeConfig.widthMultiplier,
                child: Circle(
                  gradientColors: <Color>[
                    Color(0xFF9B0707),
                    Color(0xFFFC8989),
                  ],
                  radius: 28.50 * SizeConfig.widthMultiplier,
                  gradientBegin: Alignment.topLeft,
                  gradientEnd: Alignment.bottomRight,
                ),
              ),
              Positioned(
                bottom: -7.65 * SizeConfig.widthMultiplier,
                right: -20.40 * SizeConfig.widthMultiplier,
                child: Circle(
                  radius: 48.02 * SizeConfig.widthMultiplier,
                  gradientColors: <Color>[
                    Color(0xFF8FEDFA),
                    Color(0xFF06899B),
                  ],
                  gradientBegin: Alignment.topLeft,
                  gradientEnd: Alignment.bottomRight,
                  stops: <double>[0.15, 0.75],
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: _width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.10 * SizeConfig.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 6.44 * SizeConfig.heigthMultiplier,
                        ),
                        //titulo
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 6.92 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6.44 * SizeConfig.heigthMultiplier,
                        ),
                        //logo
                        Container(
                          child: Image.asset(
                            imgLogo,
                            height: 14.47 * SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                        SizedBox(
                          height: 9.44 * SizeConfig.heigthMultiplier,
                        ),
                        //formulario
                        loginForm(),
                        SizedBox(
                          height: 8.44 * SizeConfig.heigthMultiplier,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.30 * SizeConfig.widthMultiplier,
                              vertical: 1.20 * SizeConfig.heigthMultiplier),
                          color: Color(0xFF299DAD),
                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                                fontSize: 6.37 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w400),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              _loginFormKey.currentState.save();
                              print('iniciar sesion');
                              print('email $_user');
                              print('pass $_password');
                              _loginFormKey.currentState.reset();
                            }
                          },
                        ),
                        SizedBox(
                          height: 3.44 * SizeConfig.heigthMultiplier,
                        ),
                        FlatButton(
                          child: Text(
                            'Crear una cuenta',
                            style: TextStyle(
                                fontSize: 5.59 * SizeConfig.textMultiplier),
                          ),
                          textColor: Color(0xFF04398E),
                          onPressed: () {
                            //se activan las animaciones
                            print('crear nueva cuenta');
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          //campo de email o nue
          TextFieldCustom(
            textInputAction: TextInputAction.done,
            hintText: 'Correo ó NUE',
            validator: (value) {
              if (value == '' || !value.contains('@') || value.length < 6) {
                return 'Ingresa un correo ó NUE válido';
              }
              return null;
            },
            onSave: (value) {
              _user = value;
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(focusPass);
            },
          ),
          SizedBox(
            height: 2 * SizeConfig.heigthMultiplier,
          ),
          //campo de contraseña
          TextFieldCustom(
            focusNode: focusPass,
            obscureText: true,
            hintText: 'Password',
            validator: (value) {
              if (value == '' || value.length < 8) {
                return 'Ingresa mínimo 8 caracteres';
              }
              return null;
            },
            onSave: (value) {
              _password = value;
            },
          ),
        ],
      ),
    );
  }
}
