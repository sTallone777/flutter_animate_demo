import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThunderX extends StatefulWidget {
  static String routeName = '/thunderx';

  ThunderX({Key key}) : super(key: key);

  _ThunderXState createState() => _ThunderXState();
}

class _ThunderXState extends State<ThunderX> with TickerProviderStateMixin {
  var _sides = 3.0;

  Animation<double> animation1;
  AnimationController controller1;

  Animation<double> animation2;
  AnimationController controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    Tween<double> _radiusTween = Tween(begin: 0.0, end: 200);
    Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

    animation1 = _radiusTween.animate(controller1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          controller1.reverse();
        }else if(status == AnimationStatus.dismissed){
          controller1.forward();
        }
      });

    animation2 = _rotationTween.animate(controller2)
    ..addListener(() {setState(() {

    });})
    ..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller2.reverse();
      }else if(status == AnimationStatus.dismissed){
        controller2.forward();
      }
    });

    controller1.forward();
    controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('ThunderX'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: animation1,
                builder: (context, _){
                  return CustomPaint(
                    painter: ShapePainter(_sides, animation1.value, animation2.value),
                    child: Container(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text('Sides'),
            ),
            Slider(
              value: _sides,
              min: 3.0,
              max: 10.0,
              label: _sides.toInt().toString(),
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _sides = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final double sides;
  final double radius;
  final double radians;
  ShapePainter(this.sides, this.radius, this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset startPoint =
    Offset(radius * math.cos(radians), radius * math.sin(radians));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(radians + angle * i) + center.dx;
      double y = radius * math.sin(radians + angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
