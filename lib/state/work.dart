import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ungtai/models/app_model.dart';
import 'package:ungtai/utility/my_style.dart';

class Work extends StatefulWidget {
  final List<AppModel> appModels;
  Work({Key key, this.appModels}) : super(key: key);
  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends State<Work> {
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
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: widgets,
      ),
    );
  }
}
