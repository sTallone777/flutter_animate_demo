import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

class Polyline extends StatefulWidget {
  static String routeName = '/Polyline';

  Polyline({Key key}) : super(key: key);

  _PolylineState createState() => _PolylineState();
}

///line numbers
const int num = 50;

///per duration of animations
const int perDuration = 80;

class _PolylineState extends State<Polyline> with TickerProviderStateMixin {
  AnimationController controller;
  Random r = new Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: num * perDuration),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
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
    Size s = MediaQuery.of(context).size;
    int width = s.width.floor();
    int height = s.height.floor();
    //coordinates
    List<position> pList = List();
    for (var i = 0; i < num; i++) {
      position p = new position();
      p.dx = double.parse(r.nextInt(width).toString());
      p.dy = double.parse(r.nextInt(height).toString());
      pList.add(p);
    }

    //animate distance
    String tempDistance = (1 / num).toStringAsFixed(3);
    double animateDistance = double.parse(
        tempDistance.substring(0, tempDistance.lastIndexOf('.') + 3));

    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var i = 0; i < pList.length - 1; i++)
              LinePainter(
                controller: controller,
                startX: pList[i].dx,
                startY: pList[i].dy,
                endX: pList[i + 1].dx,
                endY: pList[i + 1].dy,
                startTime: i * animateDistance,
                endTime: (i + 1) * animateDistance,
              ),
          ],
        ),
      ),
    );
  }
}

///line painter
// ignore: must_be_immutable
class LinePainter extends StatelessWidget {
  final double startX, startY, endX, endY, startTime, endTime;
  final Animation<double> controller;
  Animation<double> finalX;
  Animation<double> finalY;

  LinePainter({
    this.controller,
    this.startX,
    this.startY,
    this.endX,
    this.endY,
    this.startTime,
    this.endTime,
  }) {
    finalX = Tween<double>(
      begin: startX,
      end: endX,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeOutSine,
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
          curve: Curves.easeOutSine,
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

///line
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
      ..color = Colors.cyan
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

// ignore: camel_case_types
class position {
  double dx;
  double dy;
}
