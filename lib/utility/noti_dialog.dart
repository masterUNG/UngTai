import 'package:flutter/material.dart';
import 'package:ungtai/state/my_service.dart';
import 'package:ungtai/utility/my_style.dart';

Future<Null> notiDialog(BuildContext context, String title, String body) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: MyStyle().showLogo(),
        title: Text(title),
        subtitle: Text(body),
      ),
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyService(
                    index: 1,
                  ),
                ),
                (route) => false);
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}
