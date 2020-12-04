import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:ungtai/utility/my_constant.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:intl/intl.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  String personalID;
  List<String> subjectTypes = List();
  String subjectType, subject, content;
  File file;
  final formKey = GlobalKey<FormState>();
  bool viewContent = true; //true ==> Enable Content
  bool validateImage = true;
  String dateTimeString;
  DateTime dateTime;
  String nameImage;
  bool statusUpload = false; // false not Show Cirgura Progress
  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
    findSubjectType();
    findCurentDateTime();
  }

  Future<Null> findCurentDateTime() async {
    dateTime = DateTime.now();
    print('dateTime ==> $dateTime');
    dateTimeString = myFormatDateTime(dateTime);
  }

  String myFormatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<Null> findSubjectType() async {
    // subjectTypes = ['Type0', 'Type1', 'Type2', 'Type3', 'Type4'];

    String path =
        'https://play.intouchcompany.com/MobileService/newsapi/GetSubjectType';
    await Dio().get(path).then((value) {
      for (var item in value.data) {
        setState(() {
          subjectTypes.add(item);
        });
      }
    });
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    personalID = preferences.getString(MyConstant().employeeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => uploadImageToServer(),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Add News'),
      ),
      body: Stack(
        children: [
          buildShowContent(),
          statusUpload ? MyStyle().showProgress() : SizedBox()
        ],
      ),
    );
  }

  Center buildShowContent() {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildTextDate(),
              buildSubject(),
              buildDropdownButton(),
              buildContent(),
              buildImage(),
              buildText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextDate() => ListTile(
        leading: Icon(Icons.lock_clock),
        title: Text(dateTimeString == null ? 'Data Add :' : dateTimeString),
        subtitle: Text('Date Time Post News'),
        trailing: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => chooseDateTimeApple(),
        ),
      );

  Future<Null> chooseDateTimeApple() async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(dateTime.year - 5, dateTime.month, dateTime.day),
      maxTime: DateTime(dateTime.year + 5, dateTime.month, dateTime.day),
      onConfirm: (time) {
        setState(() {
          dateTimeString = myFormatDateTime(time);
        });
      },
    );
  }

  Future<Null> chooseDateTime() async {
    await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(dateTime.year - 5),
            lastDate: DateTime(dateTime.year + 5))
        .then((value) {
      print('value ==>> $value');
      setState(() {
        dateTimeString = myFormatDateTime(value);
      });
    });
  }

  Text buildText() => validateImage
      ? Text('If Insert Image ? Click Image')
      : Text(
          'No Image ? Please Click Image',
          style: TextStyle(color: Colors.red),
        );

  Widget buildImage() {
    return GestureDetector(
      onTap: () => chooseSource(),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 250,
        child: file == null ? Image.asset('images/pic.png') : Image.file(file),
      ),
    );
  }

  Future<Null> chooseSource() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: MyStyle().showLogo(),
          title: Text('Please Choose Type of Image ?'),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
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

  Widget buildDropdownButton() => Container(
        width: 250,
        child: subjectTypes.length == 0
            ? MyStyle().showProgress()
            : DropdownButtonFormField<String>(
                hint: Text('Please Choose subjectType'),
                value: subjectType,
                items: subjectTypes
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    subjectType = value;
                    if (subjectType == subjectTypes[1]) {
                      viewContent = false;
                      content = '';
                    } else {
                      viewContent = true;
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please Choose SubType';
                  } else {
                    return null;
                  }
                },
              ),
      );

  Container buildSubject() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      // decoration: MyStyle().textFliddBoxDecoration(),
      width: 250,
      child: TextFormField(
        controller: subjectController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Fill Subject';
          } else {
            return null;
          }
        },
        onSaved: (newValue) => subject = newValue.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.subject),
          // border: InputBorder.none,
          labelText: 'Subject :',
        ),
      ),
    );
  }

  Widget buildContent() {
    return viewContent
        ? Container(
            margin: EdgeInsets.only(top: 16),
            // decoration: MyStyle().textFliddBoxDecoration(),
            width: 250,
            child: TextFormField(
              controller: contentController,
              onSaved: (newValue) => content = newValue.trim(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Plese Fill Content In The Blank';
                } else {
                  return null;
                }
              },
              maxLines: 5,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Icon(Icons.content_copy),
                ),
                // border: InputBorder.none,
                labelText: 'Content :',
              ),
            ),
          )
        : SizedBox();
  }

  Future<Null> insertNewsToServer() async {
    String path =
        'https://play.intouchcompany.com/MobileService/newsapi/AddNews?personalID=44524&subject=$subject&subjectType=$subjectType&content=$content&imageFile=$nameImage&createdDate=$dateTimeString';
    await Dio().get(path).then((value) {
      setState(() {
        statusUpload = false;

        subject = '';
        content = '';
        subjectType = null;
        file = null;
        dateTimeString = myFormatDateTime(dateTime);
        subjectController.clear();
        contentController.clear();

        Toast.show(
          'Add News Success',
          context,
          duration: 5,
        );
      });
    });
  }

  Future<Null> uploadImageToServer() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      setState(() {
        statusUpload = true;
      });

      if (file == null) {
        nameImage = '';
        insertNewsToServer();
      } else {
        int i = Random().nextInt(100000);
        nameImage = 'news$i.jpg';

        String path =
            'https://play.intouchcompany.com/MobileService/newsapi/UploadFile';

        try {
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file.path, filename: nameImage);
          FormData formData = FormData.fromMap(map);
          await Dio().post(path, data: formData).then(
                (value) => insertNewsToServer(),
              );
        } catch (e) {}
      }

      print(
          'subject ==>> $subject, content ==>> $content, subjectType = $subjectType, dateTimeString = $dateTimeString');
    }
    if (file == null) {
      setState(() {
        validateImage = false;
      });
    }
  }
}
