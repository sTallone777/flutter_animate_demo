import 'package:flutter/material.dart';
import 'dart:math';

class ThunderX extends StatefulWidget {
  static String routeName = '/thunderx';

  ThunderX({Key key}) : super(key: key);
  _ThunderXState createState() => _ThunderXState();
}

class _ThunderXState extends State<ThunderX> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom:100.0,
              left:100.0,
              child:RaisedButton(
                color: Colors.red,
                child: Text('Start', style: TextStyle(fontSize: 20, color: Colors.white)),
                // onPressed: () {
                //   controller.forward();
                // },
                // onLongPress: (){
                //   controller.reverse();
                // },
              ),
            ),
          ],
        ),
      ),

      painter:MyPaint(),
    );
  }
}

class MyPaint extends CustomPainter{
  Paint _paint;

  MyPaint(){
    _paint = Paint();
  }

  void paint(Canvas canvas, Size size){
    _paint.color = Color(0xffeCCCCC);
    _paint.style = PaintingStyle.stroke;
    var circles = Offset(135, 250.0) & Size(130.0, 130.0);
    canvas.drawArc(
        circles, -pi / 3, pi * 3 * 5, false, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }


}