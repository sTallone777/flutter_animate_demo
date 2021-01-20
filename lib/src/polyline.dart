import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyPainter(),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter>
    with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizer'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LinePanter(controller, 100, 50, 150, 200, 0.0, 0.3),
            LinePanter(controller, 150, 200, 200, 100, 0.3, 0.6),
            LinePanter(controller, 200, 100, 400, 500, 0.6, 1.0),
          ],
        ),
      ),
    );
  }
}

// FOR PAINTING THE CIRCLE
class LinePanter extends StatelessWidget  {
  final double startX, startY, endX, endY, startTime, endTime;
  final Animation<double> controller;
  Animation<double> finalX;
  Animation<double> finalY;
  LinePanter(
    this.controller,
    this.startX,
    this.startY,
    this.endX,
    this.endY,
    this.startTime,
    this.endTime,
  ) {
    finalX = Tween<double>(
      begin: startX,
      end: endX,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.linear,
        ),
      ),
    );
    
    finalY = Tween<double>(
      begin: startY,
      end: endY,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.linear,
        ),
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return CustomPaint(
      painter: ShapePainter(startX, startY, finalX.value, finalY.value, 5),
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}


class ShapePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double sw;
  Paint _paint;
  
  ShapePainter(
    this.startX,
    this.startY,
    this.endX,
    this.endY,
    this.sw,
  ){
    _paint = Paint();
    _paint.strokeWidth = this.sw;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    //var paint = Paint()
      _paint.color = Colors.teal;
      _paint.strokeWidth = 0;
      _paint.strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(startX, startY);
    Offset endingPoint = Offset(endX, endY);

    canvas.drawLine(startingPoint, endingPoint, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

