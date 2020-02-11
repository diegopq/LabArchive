import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_archive/src/view/pages/home_page.dart';
import 'package:lab_archive/src/view/pages/login_page.dart';
import 'package:lab_archive/utils/conts.dart';
import 'package:lab_archive/utils/session.dart';
import 'package:lab_archive/utils/size_config.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final _session = Session();
  Widget page = Container();
  Size size;
  double width, height;

  @override
  void initState() {
    super.initState();

    getPage();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Container(
      width: width,
      height: height,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 9.65 * SizeConfig.heigthMultiplier,
          ),
          Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/img/logo_login.png',
              height: 28.47 * SizeConfig.imageSizeMultiplier,
            ),
          ),
          SizedBox(
            height: 9.65 * SizeConfig.heigthMultiplier,
          ),
          Container(
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 5.10 * SizeConfig.widthMultiplier,
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPage() async {
    final data = await _session.getToken();
    await Future.delayed(Duration(seconds: 3)).then((r) {
      if (data != null) {
        Navigator.pushReplacementNamed(context, HomePage.namePage);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.namePage);
      }
    });
  }
}
