import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:ungtai/utility/my_style.dart';

class Memo extends StatefulWidget {
  @override
  _MemoState createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  ui.Image image;
  bool isImageLoad = false;
  GlobalKey<_MemoState> canvasKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<Null> init() async {
    final ByteData byteData = await rootBundle.load('images/paper2.png');
    image = await loadImage(Uint8List.view(byteData.buffer));
  }

  Future<ui.Image> loadImage(List<int> list) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(list, (result) {
      print('rander image success');
      setState(() {
        isImageLoad = true;
      });
      return completer.complete(result);
    });
    return completer.future;
  }

  Future<Null> saveImage() async {
    var object = await recordProcess;
    print('object ==> ${object.toString()}');
  }

  Future<ui.Image> get recordProcess async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var size = context.size;
    return recorder.endRecording().toImage(300, 300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isImageLoad
          ? Stack(
              children: [
                buildSignature(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              canvasKey.currentState.
                            });
                          },
                          child: Text('Clear'),
                        ),
                        ElevatedButton(
                          onPressed: () => saveImage(),
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : MyStyle().showProgress(),
    );
  }

  Widget buildSignature() {
    ImageEditor imageEditor = ImageEditor(image: image);
    return GestureDetector(
      onPanDown: (details) {
        imageEditor.update(details.localPosition);
        canvasKey.currentContext.findRenderObject().markNeedsPaint();
      },
      onPanUpdate: (details) {
        imageEditor.update(details.localPosition);
        canvasKey.currentContext.findRenderObject().markNeedsPaint();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 150,
        // color: Colors.grey,
        child: CustomPaint(
          key: canvasKey,
          painter: imageEditor,
        ),
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  ui.Image image;

  ImageEditor({this.image});

  List<Offset> points = List();
  final Paint painter = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

  void update(Offset offset) {
    points.add(offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawImage(image, Offset(0.0, 0.0), Paint());
    for (var offset in points) {
      canvas.drawCircle(offset, 5, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}
