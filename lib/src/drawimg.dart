
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawImg extends StatefulWidget {
  DrawImg({Key key}) : super(key: key);
  static String routeName = '/drawimg';
  @override
  _DrawImgState createState() => new _DrawImgState();
}

class _DrawImgState extends State<DrawImg> {
  ui.Image image;
  bool isImageloaded = false;

  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('assets/suitosakura.jpg');
    image = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    if (this.isImageloaded) {
      return new CustomPaint(
        painter: new ImageEditor(image: image),
      );
    } else {
      return new Center(child: new Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('DrawImage'),
        ),
        body: new Container(
          child: _buildImage(),
        )
    );
  }
}

class ImageEditor extends CustomPainter {


  ImageEditor({
    this.image,
  });

  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    var data = image.toByteData();
    canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}