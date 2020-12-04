import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ungtai/models/app_model.dart';
import 'package:ungtai/utility/my_style.dart';
import 'package:url_launcher/url_launcher.dart';

class Personal extends StatefulWidget {
  final List<AppModel> appModels;
  Personal({Key key, this.appModels}) : super(key: key);
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  List<AppModel> appModels;
  List<Widget> widgets = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createWidgets();
  }

  void createWidgets() {
    appModels = widget.appModels;
    int index = 0;
    for (var item in appModels) {
      setState(() {
        widgets.add(createWidget(item.imgSrc, index));
      });
      index++;
    }
  }

  Widget createWidget(String urlImage, int index) {
    String string = urlImage.substring(1);
    string = 'http://wp.intouchcompany.com$string';
    // print('string ==>> $string');
    return GestureDetector(
      onTap: () {
        print('You Click Index ==>> $index');
        chooseRequest(appModels[index]);
      },
      child: Card(
        child: CachedNetworkImage(
          imageUrl: string,
          placeholder: (context, url) => MyStyle().showProgress(),
          errorWidget: (context, url, error) => Image.asset('images/logo.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        children: widgets,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }

  Future<Null> chooseRequest(AppModel appModel) async {
    String string = appModel.imgSrc.substring(1);
    string = 'http://wp.intouchcompany.com$string';
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: CachedNetworkImage(
          imageUrl: string,
          placeholder: (context, url) => MyStyle().showProgress(),
          errorWidget: (context, url, error) => Image.asset('images/logo.png'),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  openWebSite(appModel.href);
                  Navigator.pop(context);
                },
                child: Text('Website'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('InApp'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> openWebSite(String href) async {
    if (await canLaunch(href)) {
      await launch(href);
    }
  }
}
