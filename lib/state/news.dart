import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungtai/models/news_model.dart';
import 'package:ungtai/state/add_news.dart';
import 'package:ungtai/utility/my_style.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool statusAddNew = true; // true Can Add News
  List<NewsModel> newsModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllNews();
  }

  Future<Null> readAllNews() async {
    print('readAllNew Work');
    String path =
        'https://play.intouchcompany.com/MobileService/newsapi/GetAllNews?pageNumber=1&rowsOfPage=20';
    await Dio().get(path).then((value) {
      // print('value ==>> $value');
      for (var json in value.data) {
        NewsModel model = NewsModel.fromJson(json);
        setState(() {
          newsModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: statusAddNew
          ? FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNews(),
                ),
              ).then((value) => readAllNews()),
              child: Icon(Icons.add),
            )
          : SizedBox(),
      body: newsModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: newsModels.length,
              itemBuilder: (context, index) => ExpansionTile(
                subtitle: Text(showDate(newsModels[index].createdDate)),
                leading: Icon(Icons.subject),
                title: Text(
                  newsModels[index].subject,
                  style: MyStyle().darkH1(),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        print('You Click index $index');
                        showDetailNews(newsModels[index]);
                      },
                      child: Row(
                        children: [
                          buildContainerLeft(context, index),
                          buildContainerRigth(context, index),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container buildContainerRigth(BuildContext context, int index) {
    return Container(
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.4 - 16,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl:
            'https://play.intouchcompany.com/MobileService/Files/${newsModels[index].imageFile}',
        placeholder: (context, url) => MyStyle().showProgress(),
        errorWidget: (context, url, error) => SizedBox(),
      ),
    );
  }

  Container buildContainerLeft(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.4 - 16,
      child: Container(
        // color: Colors.grey,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.5 - 16,
                    child: Text(
                      'Type : ${newsModels[index].subjectType}',
                      style: MyStyle().darkH2(),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: Text(
                    subContent(newsModels[index].content),
                    style: MyStyle().darkH3(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String subContent(String content) {
    String result = content;
    if (result.length > 50) {
      result = result.substring(0, 50);
      result = '$result ...';
    }
    return result;
  }

  Future<Null> showDetailNews(NewsModel newsModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: MyStyle().showLogo(),
          title: Text(newsModel.subject),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl:
                  'https://play.intouchcompany.com/MobileService/Files/${newsModel.imageFile}',
              placeholder: (context, url) => MyStyle().showProgress(),
              errorWidget: (context, url, error) => SizedBox(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Content :',
              style: MyStyle().darkH2(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(newsModel.content),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK')),
            ],
          )
        ],
      ),
    );
  }

  String showDate(String createdDate) {
    
    List<String> list = createdDate.split('T');
    if (list[0] == null) {
      return '';
    } else {
      return list[0];
    }
  }
}
