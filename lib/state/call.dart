import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungtai/models/login_model.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:ungtai/utility/normal_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  int pageNumber = 1;
  int rowsOfPage = 20;
  List<LoginModel> loginModels = List();
  List<LoginModel> filterLoginModels = List();
  ScrollController scrollController = ScrollController();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    textEditingController.addListener(() {
      String string = textEditingController.text;
      processSearchView(string);
    });

    setupScrollController();
    readCall();
  }

  void setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('This is End');
        pageNumber++;
        readCall();
      }
    });
  }

  Future<Null> readCall() async {
    String path =
        'https://play.intouchcompany.com/MobileService/restapi/GetAllMobileNo?pageNumber=$pageNumber&rowsOfPage=$rowsOfPage';
    await Dio().get(path).then((value) {
      // print('valute ==>> $value');
      if (value.toString() != '[]') {
        var result = value.data;
        for (var item in result) {
          LoginModel model = LoginModel.fromJson(item);
          setState(() {
            loginModels.add(model);
            filterLoginModels = loginModels;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginModels.length == 0 ? MyStyle().showProgress() : buildContent(),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          decoration: MyStyle().textFliddBoxDecoration(),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    textEditingController.clear();
                  }),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search Name',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: ScrollPhysics(),
            controller: scrollController,
            itemCount: filterLoginModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                confirmCall(filterLoginModels[index]);
              },
              child: Card(
                color: index % 2 == 0
                    ? Colors.green.shade100
                    : Colors.green.shade300,
                child: ListTile(
                  leading: buildCachedNetworkImage(index),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filterLoginModels[index].fullName),
                      Text(filterLoginModels[index].email),
                      Text(filterLoginModels[index].department),
                    ],
                  ),
                  trailing: Icon(Icons.phone),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void processSearchView(String value) {
    debouncer.run(() {
      setState(() {
        filterLoginModels = loginModels
            .where((element) =>
                (element.fullName.toLowerCase().contains(value.toLowerCase())))
            .toList();
      });
    });
  }

  CircleAvatar buildCircleAvatar(int index) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
          'https://play.intouchcompany.com/MobileService${loginModels[index].imageFile}'),
    );
  }

  CachedNetworkImage buildCachedNetworkImage(int index) {
    return CachedNetworkImage(
        errorWidget: (context, url, error) => Image.asset('images/logo.png'),
        placeholder: (context, url) => MyStyle().showProgress(),
        imageUrl:
            'https://play.intouchcompany.com/MobileService${loginModels[index].imageFile}');
  }

  Future<Null> confirmCall(LoginModel loginModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: MyStyle().showLogo(),
          title: Text('Do You Want Call to ${loginModel.fullName}'),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processCall(loginModel);
                },
                child: Text('Call'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> processCall(LoginModel loginModel) async {
    String callString = 'tel:${loginModel.mobileNo}';
    if (await canLaunch(callString)) {
      await launch(callString);
    } else {
      normalDialog(context, 'Sorry ? Cannot Call to ${loginModel.mobileNo}');
    }
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback voidCallback;
  Timer timer;

  Debouncer({this.milliseconds});

  run(VoidCallback voidCallback) {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), voidCallback);
  }
}
