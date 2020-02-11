import 'package:flutter/material.dart';
import 'package:lab_archive/src/view/pages/evidence_page.dart';
import 'package:lab_archive/src/view/pages/home_page.dart';
import 'package:lab_archive/src/view/pages/list_activities_page.dart';
import 'package:lab_archive/src/view/pages/login_page.dart';
import 'package:lab_archive/src/view/pages/register_page.dart';
import 'package:lab_archive/src/view/pages/select_course_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //obtener los enviados en Navigator.pushNamed
    final _args = settings.arguments;

    switch (settings.name) {
      //pagina de login
      case 'LoginPage':
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      case 'RegisterPage':
        return MaterialPageRoute(
            builder: (BuildContext context) => RegisterPage());
      case 'HomePage':
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      case 'CreateSubjectPage':
        return MaterialPageRoute(
            builder: (BuildContext context) => SelectCoursePage());
      case 'ListActivitiesPage':
        return MaterialPageRoute(
            builder: (BuildContext context) => ListActivitiesPage(
                  assignature: _args,
                ));
      case 'EvidencePage':
        return MaterialPageRoute(
            builder: (BuildContext context) => EvidencePage(
                  arguments: _args,
                ));
      // case 'ShowImagePage':
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => ShowImagePage(
      //             arguments: _args,
      //           ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => LoginPage());
  }
}
