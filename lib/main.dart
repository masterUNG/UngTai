import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ungtai/state/signin.dart';

Future<Null> main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

// main() => runApp(MyApp());

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus &&
            focusScopeNode.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignIn(),
        theme: ThemeData(
            primaryColor: Colors.deepOrange,
            primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.purple),
            ),
            primaryIconTheme: IconThemeData(color: Colors.purple)),
      ),
    );
  }
}
