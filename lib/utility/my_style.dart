import 'package:flutter/material.dart';

class MyStyle {
  BoxDecoration textFliddBoxDecoration() {
    return BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(30),
    );
  }

  Widget showLogo() => Image.asset('images/logo.png');

  Widget showProgress() => Center(child: CircularProgressIndicator());

  TextStyle whiteText() => TextStyle(color: Colors.white);

  TextStyle darkH1() => TextStyle(
        color: Colors.green.shade700,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle darkH2() => TextStyle(
        color: Colors.brown.shade700,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  TextStyle darkH3() => TextStyle(
        color: Colors.blue.shade700,
        fontSize: 14,
      );

  MyStyle();
}
