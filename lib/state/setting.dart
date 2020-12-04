import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtai/models/login_model.dart';
import 'package:ungtai/utility/my_constant.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:ungtai/utility/normal_dialog.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String personalID;
  LoginModel loginModel;
  File file;
  String phone;
  String nameFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    personalID = preferences.getString(MyConstant().employeeID);
    print('personalID ==> $personalID');

    String path =
        'https://play.intouchcompany.com/MobileService/restapi/GetAbout?personalID=$personalID';
    await Dio().get(path).then((value) {
      print('value ==>> $value');
      setState(() {
        loginModel = LoginModel.fromJson(value.data);
        phone = loginModel.mobileNo;
        nameFile = loginModel.imageFile;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (file == null && phone == loginModel.mobileNo) {
            normalDialog(context, 'Not Something Else');
          } else {
            if (file != null) {
              // Image Change
              uploadImageToServer();
            } else {
              // Image Not Change
              editProfile();
            }
          }
        },
        child: Icon(Icons.cloud_upload),
      ),
      body: Center(
        child: loginModel == null ? MyStyle().showProgress() : buildContent(),
      ),
    );
  }

  Future<Null> uploadImageToServer() async {
    int i = Random().nextInt(1000000);
    nameFile = 'avatar$i.jpg';
    print('nameFile ==>> $nameFile');
    String path =
        'https://play.intouchcompany.com/MobileService/restapi/UploadFile';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      await Dio().post(path, data: formData).then((value) {
        print('Success Upload');
        editProfile();
      }).catchError((value) {
        print('UnSuccess value ==>> ${value.message}');
      });
    } catch (e) {
      print('e upload ==>> ${e.toString()}');
    }
  }

  Future<Null> editProfile() async {
    String path = '';
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildContainerImage(),
          buildListTilePersonal(),
          buildListTileFullName(),
          buildListTileType(),
          buildListTilePhone(),
        ],
      ),
    );
  }

  ListTile buildListTilePhone() {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Container(
        decoration: MyStyle().textFliddBoxDecoration(),
        child: TextFormField(
          onChanged: (value) => phone = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16),
            border: InputBorder.none,
          ),
          initialValue: loginModel.mobileNo,
        ),
      ),
    );
  }

  ListTile buildListTilePersonal() {
    return ListTile(
      leading: Icon(Icons.fingerprint),
      title: Text('Personal No : ${loginModel.personalID}'),
    );
  }

  ListTile buildListTileFullName() {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(loginModel.fullName),
    );
  }

  ListTile buildListTileType() {
    return ListTile(
      leading: Icon(Icons.network_cell),
      title: Text(loginModel.department),
    );
  }

  Container buildContainerImage() {
    return Container(
      // color: Colors.grey,
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseSourceImage(ImageSource.camera)),
          buildShowImage(),
          IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseSourceImage(ImageSource.gallery)),
        ],
      ),
    );
  }

  Future<Null> chooseSourceImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Widget buildShowImage() {
    return file == null
        ? buildCachedNetworkImage()
        : Container(
            width: 250,
            child: Image.file(file),
          );
  }

  CachedNetworkImage buildCachedNetworkImage() {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width * 0.4,
      imageUrl:
          'https://play.intouchcompany.com/MobileService${loginModel.imageFile}',
      placeholder: (context, url) => MyStyle().showProgress(),
      errorWidget: (context, url, error) => Image.asset('images/logo.png'),
    );
  }
}
