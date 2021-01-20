import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Polyline extends StatefulWidget {
  static String routeName = '/Polyline';
  Polyline({Key key}) : super(key : key);

  _PolylineState createState() => _PolylineState();
}

class _PolylineState extends State<Polyline> with TickerProviderStateMixin {

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
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline'),
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
          curve: Curves.easeOutCirc,
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
          curve: Curves.easeOutCirc,
        ),
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return CustomPaint(
      painter: ShapePainter(startX, startY, finalX.value, finalY.value),
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
  
  ShapePainter(
    this.startX,
    this.startY,
    this.endX,
    this.endY,
  );
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;

    Offset startingPoint = Offset(startX, startY);
    Offset endingPoint = Offset(endX, endY);

    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
