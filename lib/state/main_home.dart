import 'package:flutter/material.dart';
import 'package:ungtai/state/approval.dart';
import 'package:ungtai/state/workplace.dart';

class MainHome extends StatefulWidget {
  final int index;
  MainHome({Key key, this.index}) : super(key: key);
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List<Widget> widgets = [WorkPlace(), Approval()];
  int index = 0;
  List<String> titles = ['WorkPlace', 'Approval'];
  List<IconData> iconDatas = [Icons.edit];
  List<BottomNavigationBarItem> bottonNavs = List();
  List<IconData> iconApprovals = [
    Icons.filter_none,
    Icons.filter_1,
    Icons.filter_2,
    Icons.filter_3,
    Icons.filter_4,
    Icons.filter_5,
    Icons.filter_6,
    Icons.filter_7,
    Icons.filter_8,
    Icons.filter_9,
    Icons.filter_9_plus
  ];
  int indexApproval;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int appIndex = widget.index;
    if (appIndex != null) {
      index = appIndex;
    }

    indexApproval = 10;
    iconDatas.add(iconApprovals[indexApproval]);

    createWidgets();
  }

  void createWidgets() {
    int index = 0;
    for (var item in titles) {
      bottonNavs.add(createBottomNavigatorItem(item, iconDatas[index]));
      index++;
    }
  }

  BottomNavigationBarItem createBottomNavigatorItem(
      String title, IconData iconData) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: title,
      // title: Text('Master1'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[index],
      bottomNavigationBar: BottomNavigationBar(
        items: bottonNavs,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
