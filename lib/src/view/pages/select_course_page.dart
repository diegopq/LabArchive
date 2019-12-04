import 'package:flutter/material.dart';
import 'package:lab_archive/src/model/api/crud_api.dart';
import 'package:lab_archive/src/model/assignature_model.dart';
import 'package:lab_archive/src/view/widgets/loading_indicator.dart';
import 'package:lab_archive/utils/size_config.dart';

class SelectCoursePage extends StatefulWidget {
  static final String namePage = 'CreateSubjectPage';

  @override
  _SelectCoursePageState createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends State<SelectCoursePage> {
  CrudAPI _apiCrud = CrudAPI();
  List<AssignatureModel> _listOfAssignatures;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignatures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        body: FutureBuilder<List<AssignatureModel>>(
          future: _apiCrud.getAssignatures(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].key),
                        trailing: Icon(Icons.add),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              );
            } else {
              return LoadingIndicator();
            }
          },
        )
        //LoadingIndicator(),
        );
  }

  Future<void> getAssignatures() async {
    _listOfAssignatures = await _apiCrud.getAssignatures();
  }
}
