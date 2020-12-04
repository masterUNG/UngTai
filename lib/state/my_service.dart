import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtai/state/call.dart';
import 'package:ungtai/state/main_home.dart';
import 'package:ungtai/state/memo.dart';
import 'package:ungtai/state/news.dart';
import 'package:ungtai/state/setting.dart';
import 'package:ungtai/state/signin.dart';
import 'package:ungtai/utility/my_constant.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:ungtai/utility/normal_dialog.dart';
import 'package:ungtai/utility/noti_dialog.dart';

class MyService extends StatefulWidget {
  final int index;
  MyService({Key key, this.index}) : super(key: key);
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  Widget currentWidget;
  String nameLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int appIndex = widget.index;
    if (appIndex != null) {
      currentWidget = MainHome(
        index: 1,
      );
    } else {
      currentWidget = MainHome();
    }

    getDataLogin();
    findToken();
  }

  Future<Null> findToken() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseMessaging messaging = FirebaseMessaging();
      String token = await messaging.getToken();
      print('initila Success and token ==>> $token');

      messaging.configure(
        onMessage: (message) async {
          print('onMessage onService ==>>> ${message.toString()}');
          String title = message['notification']['title'];
          String body = message['notification']['body'];
          notiDialog(context, title, body);
        },
        onResume: (message) async {
          print('onResume  ==>>> ${message.toString()}');
          String title = message['date']['title'];
          String body = message['date']['body'];
          notiDialog(context,  title, body);
        },
      );
    });
  }

  void routToMyService() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyService(
            index: 1,
          ),
        ),
        (route) => false);
  }

  Future<Null> getDataLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameLogin = preferences.getString(MyConstant().fullName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: currentWidget,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Stack(
        children: [
          buildSignOutAnExit(),
          SingleChildScrollView(
            child: Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileHome(),
                buildListTileSetting(),
                buildListTileCall(),
                buildListTileNews(),
                buildListTileMemo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text('Name'),
      accountEmail: Text('Login'),
    );
  }

  Column buildSignOutAnExit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildListTileSignOut(),
        buildListTileExit(),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(nameLogin == null ? 'Name Login' : nameLogin),
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () => exit(0),
        ),
      ],
    );
  }

  ListTile buildListTileHome() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = MainHome();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.home,
        size: 36,
      ),
      title: Text(
        'Home',
      ),
      subtitle: Text(
        'Main Home',
      ),
    );
  }

  ListTile buildListTileSetting() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = Setting();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.settings,
        size: 36,
      ),
      title: Text(
        'Setting',
      ),
      subtitle: Text(
        'For Setting Parameter',
      ),
    );
  }

  ListTile buildListTileCall() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = Call();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.call,
        size: 36,
      ),
      title: Text(
        'Call',
      ),
    );
  }

  ListTile buildListTileNews() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = News();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.new_releases,
        size: 36,
      ),
      title: Text(
        'New',
      ),
    );
  }

  ListTile buildListTileMemo() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = Memo();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.memory,
        size: 36,
      ),
      title: Text(
        'Memo',
      ),
    );
  }

  ListTile buildListTileExit() {
    return ListTile(
      tileColor: Colors.red.shade900,
      onTap: () {
        exit(0);
      },
      leading: Icon(
        Icons.exit_to_app,
        size: 36,
        color: Colors.white,
      ),
      title: Text(
        'Exit',
        style: MyStyle().whiteText(),
      ),
      subtitle: Text(
        'Exit Application',
        style: MyStyle().whiteText(),
      ),
    );
  }

  ListTile buildListTileSignOut() {
    return ListTile(
      tileColor: Colors.red.shade300,
      onTap: () {
        clearAndBackSignIn();
      },
      leading: Icon(Icons.outbox, size: 36, color: Colors.white),
      title: Text(
        'SignOut',
        style: MyStyle().whiteText(),
      ),
      subtitle: Text(
        'SignOut and Login Other Account',
        style: MyStyle().whiteText(),
      ),
    );
  }

  Future<Null> clearAndBackSignIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
        (route) => false);
  }
}
