import 'package:flutter/material.dart';
import 'package:lab_archive/src/model/user_model.dart';
import 'package:lab_archive/src/view/pages/home_page.dart';
import 'package:lab_archive/src/view/pages/login_page.dart';
import 'package:lab_archive/src/view/widgets/circle.dart';
import 'package:lab_archive/src/view/widgets/text_field_custom.dart';
import 'package:lab_archive/utils/conts.dart';
import 'package:lab_archive/utils/size_config.dart';

class RegisterPage extends StatefulWidget {
  static final String namePage = 'RegisterPage';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Size _size;
  double _width;
  double _height;
  String _password;
  FocusNode _focusLastName;
  FocusNode _focusNue;
  FocusNode _focusEmail;
  FocusNode _focusPass;
  FocusNode _focusConfirmPass;
  UserModel _user = UserModel();

  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusLastName = FocusNode();
    _focusNue = FocusNode();
    _focusEmail = FocusNode();
    _focusPass = FocusNode();
    _focusConfirmPass = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusLastName.dispose();
    _focusNue.dispose();
    _focusEmail.dispose();
    _focusPass.dispose();
    _focusConfirmPass.dispose();
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
              //circulo verde
              Positioned(
                left: -40.00 * SizeConfig.widthMultiplier,
                top: -3.20 * SizeConfig.widthMultiplier,
                child: Circle(
                  radius: 49.02 * SizeConfig.widthMultiplier,
                  gradientColors: <Color>[
                    Color(0xFF8FEDFA),
                    Color(0xFF06899B),
                  ],
                  gradientBegin: Alignment.bottomRight,
                  gradientEnd: Alignment.topLeft,
                  stops: <double>[0.15, 0.75],
                ),
              ),
              //Circulo rojo
              Positioned(
                bottom: -5.65 * SizeConfig.widthMultiplier,
                right: -10.40 * SizeConfig.widthMultiplier,
                child: Circle(
                  gradientColors: <Color>[
                    Color(0xFF9B0707),
                    Color(0xFFFC8989),
                  ],
                  radius: 28.50 * SizeConfig.widthMultiplier,
                  gradientBegin: Alignment.bottomRight,
                  gradientEnd: Alignment.topLeft,
                ),
              ),
              SingleChildScrollView(
                child: SafeArea(
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
                          'Registrate',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 6.92 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8.44 * SizeConfig.heigthMultiplier,
                        ),
                        //formulario
                        loginForm(),
                        SizedBox(
                          height: 3.90 * SizeConfig.heigthMultiplier,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.30 * SizeConfig.widthMultiplier,
                              vertical: 1.20 * SizeConfig.heigthMultiplier),
                          color: Color(0xFF299DAD),
                          child: Text(
                            'Registrar',
                            style: TextStyle(
                                fontSize: 6.37 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w400),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            if (_registerFormKey.currentState.validate()) {
                              _registerFormKey.currentState.save();
                              print('iniciar sesion');
                              _user.showUserData();
                              _registerFormKey.currentState.reset();
                              Navigator.pushReplacementNamed(
                                  context, HomePage.namePage);
                            }
                          },
                        ),
                        SizedBox(
                          height: 3.44 * SizeConfig.heigthMultiplier,
                        ),
                        //ir al login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '¿Ya tienes cuenta?',
                              style: TextStyle(
                                  fontSize: 3.59 * SizeConfig.textMultiplier,
                                  color: Colors.white),
                            ),
                            FlatButton(
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Inicia sesión',
                                style: TextStyle(
                                    fontSize: 3.59 * SizeConfig.textMultiplier),
                              ),
                              textColor: Color(0xFF04398E),
                              onPressed: () {
                                //se activan las animaciones
                                print('Ingresar en cuenta');
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
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
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
          //campo de nombre
          TextFieldCustom(
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            hintText: 'Nombre',
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingresa un nombre válido';
              }
              return null;
            },
            onSave: (value) {
              _user.setName = value;
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_focusLastName);
            },
          ),
          SizedBox(
            height: 1.7 * SizeConfig.heigthMultiplier,
          ),
          //campo apellido
          TextFieldCustom(
            focusNode: _focusLastName,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            hintText: 'Apellidos',
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingresa un nombre válido';
              }
              return null;
            },
            onSave: (value) {
              _user.setLastName = value;
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_focusNue);
            },
          ),
          SizedBox(
            height: 1.7 * SizeConfig.heigthMultiplier,
          ),
          //campo Nue
          TextFieldCustom(
            maxLength: 6,
            focusNode: _focusNue,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            hintText: 'NUE',
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingresa un NUE válido';
              }
              if (value.length < 6) {
                return 'El NUE debe tener 6 dígitos';
              }
              return null;
            },
            onSave: (value) {
              _user.setNue = value;
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_focusEmail);
            },
          ),
          SizedBox(
            height: 1.7 * SizeConfig.heigthMultiplier,
          ),
          //campo email
          TextFieldCustom(
            focusNode: _focusEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            hintText: 'Email',
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Ingresa un email válido';
              }
              return null;
            },
            onSave: (value) {
              _user.setEmail = value;
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_focusPass);
            },
          ),
          SizedBox(
            height: 1.7 * SizeConfig.heigthMultiplier,
          ),
          //campo de contraseña
          TextFieldCustom(
            focusNode: _focusPass,
            obscureText: true,
            hintText: 'Password',
            validator: (value) {
              if (value.isEmpty || value.length < 8) {
                return 'Ingresa mínimo 8 caracteres';
              }
              return null;
            },
            onSave: (value) {
              _user.setPass = value;
            },
            onSubmit: (value) {
              _user.setPass = value;
              FocusScope.of(context).requestFocus(_focusConfirmPass);
            },
          ),
          SizedBox(
            height: 1.7 * SizeConfig.heigthMultiplier,
          ),
          //campo confirmar contraseña
          TextFieldCustom(
            focusNode: _focusConfirmPass,
            obscureText: true,
            hintText: 'Confirmar Password',
            validator: (value) {
              if (value.isEmpty || value.length < 8) {
                return 'Ingresa mínimo 8 caracteres';
              }
              if (_user.password != value) {
                return 'Las contraseñas son diferentes';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
