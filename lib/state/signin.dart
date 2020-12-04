import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtai/models/user_model.dart';
import 'package:ungtai/state/main_home.dart';
import 'package:ungtai/state/my_service.dart';
import 'package:ungtai/utility/my_constant.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:ungtai/utility/normal_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool statusRedEye = true;
  bool statusRemember = false;
  bool status = true;
  String user, password;
  String enCodePassword;
  UserModel model;

  @override
  void initState() {
    super.initState();
    checkStatus();
    findToken();
  }

  Future<Null> findToken() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseMessaging messaging = FirebaseMessaging();
      String token = await messaging.getToken();
      print('initila Success and token ==>> $token');

      messaging.configure(
        onMessage: (message)async {
          print('onMessage');
          normalDialog(context, 'Have Message onMessage Please SingIn');
        },
        onResume: (message)async {
          print('onResume');
          normalDialog(context, 'Have Message onResume Please SingIn');
        },
      );
    });
  }

  Future checkStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString('username');
    if (username == null || username.isEmpty) {
      setState(() {
        status = false;
      });
    } else {
      routeToService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status ? MyStyle().showProgress() : buildContent(context),
    );
  }

  Container buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.0,
          colors: <Color>[Colors.white, Colors.purple.shade900],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildLogo(context),
            buildTextFieldUser(),
            buildTextFieldPassword(),
            buildRemember(context),
            buildLogin(context)
          ],
        ),
      ),
    );
  }

  Container buildLogin(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.blue.shade700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          // print('user = $user, password = $password');
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            print('Have Space');
            normalDialog(context, 'Have Space ? Please Fill Every Blank');
          } else {
            print('user = $user, password = $password');
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> saveRemember() async {
    // user = 'kittipat';
    // password = 'Cross00#3';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (statusRemember) {
      preferences.setString('username', user);
      preferences.setString('password', enCodePassword);
    }
    preferences.setString(MyConstant().employeeID, model.employeeID);
    preferences.setString(MyConstant().fullName, model.fullName);
    preferences.setString(MyConstant().firstName, model.firstName);
    preferences.setString(MyConstant().lastName, model.lastName);
    preferences.setString(MyConstant().email, model.email);
    preferences.setString(MyConstant().telephoneNumber, model.telephoneNumber);
    preferences.setString(MyConstant().jobTitle, model.jobTitle);

    routeToService();
  }

  void routeToService() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyService(),
        ),
        (route) => false);
  }

  Future<Null> checkAuthen() async {
    enCodePassword = Uri.encodeComponent(password);
    print('enCodePassword ==>> $enCodePassword');

    String path =
        'https://play.intouchcompany.com/MobileService/restapi/GetUserInfo?userName=$user&password=$enCodePassword';
    print('path = $path');

    try {
      var response = await Dio().get(path);
      print('statusCode = ${response.statusCode}');
      print('response ==>> $response');

      model = UserModel.fromJson(response.data);
      bool status = model.processResult.isError;
      print('status ==> $status');
      if (status) {
        normalDialog(context, model.processResult.message);
      } else {
        saveRemember();
      }
    } catch (e) {
      print('Error Dio => ${e.toString()}');
    }
  }

  Container buildRemember(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Remember Me'),
        value: statusRemember,
        onChanged: (value) {
          setState(() {
            statusRemember = !statusRemember;
          });
        },
      ),
    );
  }

  Container buildTextFieldUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: MyStyle().textFliddBoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          hintText: 'User Name',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.account_box),
        ),
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: MyStyle().textFliddBoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: statusRedEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              }),
          hintText: 'Password',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Container buildLogo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Image.asset('images/logo.png'),
    );
  }
}
