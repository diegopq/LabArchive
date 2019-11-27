import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_archive/src/view/pages/home_page.dart';
import 'package:lab_archive/src/view/pages/login_page.dart';
import 'package:lab_archive/utils/size_config.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig()
                .init(constraints: constraints, orientation: orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'SourceSansPro'),
              title: 'LabArchive',
              home: InitPage(),
            );
          },
        );
      },
    );
  }
}

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
