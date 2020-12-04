import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungtai/models/app_model.dart';
import 'package:ungtai/state/personal.dart';
import 'package:ungtai/state/work.dart';
import 'package:ungtai/utility/my_style.dart';

class WorkPlace extends StatefulWidget {
  @override
  _WorkPlaceState createState() => _WorkPlaceState();
}

class _WorkPlaceState extends State<WorkPlace> {
  List<Widget> widgets = List();
  List<String> titles = ['Personal', 'Work'];
  List<IconData> iconDatas = [Icons.account_box, Icons.work];
  List<Widget> tabWidgets = List();

  List<AppModel> appModelPersonals = List();
  List<AppModel> appModelWorks = List();

  @override
  void initState() {
    super.initState();
    createTabWidget();
    readData();
  }

  Future<Null> readData() async {
    String path =
        'https://play.intouchcompany.com/MobileService/workplaceApi/GetMainIcon?isIntra=true';
    await Dio().get(path).then((value) {
      print('######## value ==>> $value');
      var result = value.data;
      for (var item in result) {
        AppModel model = AppModel.fromJson(item);
        if (model.tab == 'PERSONAL') {
          // for Personal
          setState(() {
            appModelPersonals.add(model);
          });
        } else {
          // for Work
          setState(() {
            appModelWorks.add(model);
          });
        }
      }

      widgets.add(Personal(
        appModels: appModelPersonals,
      ));
      widgets.add(Work(
        appModels: appModelWorks,
      ));
    });
  }

  void createTabWidget() {
    int index = 0;
    for (var item in titles) {
      tabWidgets.add(Column(
        children: [
          Icon(
            iconDatas[index],
          ),
          Text(item),
        ],
      ));

      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appModelPersonals.length == 0
          ? MyStyle().showProgress()
          : buildDefaultTabController(),
    );
  }

  DefaultTabController buildDefaultTabController() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Home'),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: tabWidgets,
            labelColor: Colors.blue.shade700,
          ),
        ),
        body: TabBarView(children: widgets),
      ),
    );
  }
}
