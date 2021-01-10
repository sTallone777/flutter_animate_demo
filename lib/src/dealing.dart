import 'package:flutter/material.dart';

const double cardWidth = 80.0;
const int cardNum = 54;
const int animateDuration = 200;
/// This is the stateful widget that the main application instantiates.
class Dealing extends StatefulWidget {
  static String routeName = '/dealing';
  Dealing({Key key}) : super(key: key);

  @override
  _DealingState createState() => _DealingState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _DealingState extends State<Dealing> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: animateDuration * cardNum),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double lb = s.width / 2 - cardWidth / 2;  //middle position
    double distance = 10.0; //card distance
    //animate duration of per card(two decimal)
    String tempDistance = (1 / cardNum).toStringAsFixed(3);
    double animateDistance = double.parse(tempDistance.substring(0, tempDistance.lastIndexOf('.') + 3));

    int col = ((s.width - distance) / (cardWidth + distance)).floor();
    int row = (cardNum / col).ceil();
    //for center
    int nonFixedWidth = ((s.width - (cardWidth + distance) * col) / 2).floor();
    double offset = nonFixedWidth - distance / 2 >= 0 ? nonFixedWidth - distance / 2 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dealing'),
      ),
      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 100.0,
                left: s.width / 2 - 50,
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 30.0,
                  child: RaisedButton(
                    child: Text('Deal', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      _controller.forward();
                    },
                  ),
                ),
              ),
              //create card by loop
              for(var i = 0; i < row; i++)
                for(var j = 0; j < col; j++)
                  CustomCard(
                    controller: _controller,
                    leftBegin: lb,
                    leftEnd: distance * (j + 1) + cardWidth * j + offset,
                    topBegin: s.height,
                    topEnd: distance * (i + 1),
                    interval: (i * col + j) * animateDistance,
                    time: (i * col + (j + 1)) * animateDistance,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({
    Key key,
    this.controller,
    this.leftBegin,
    this.leftEnd,
    this.topBegin,
    this.topEnd,
    this.interval,
    this.time,
  }) : super(key: key) {
    left = Tween<double>(
      begin: leftBegin,
      end: leftEnd,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          interval,
          time,
          curve: Curves.linear,
        ),
      ),
    );

    top = Tween<double>(
      begin: topBegin,
      end: topEnd,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          interval,
          time,
          curve: Curves.linear,
        ),
      ),
    );
  }

  final Animation<double> controller;
  final double ratio = 341 / 498;
  double leftBegin, leftEnd, topBegin, topEnd, interval, time;
  Animation<double> left;
  Animation<double> top;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      left: left.value,
      top: top.value,
      width: cardWidth,
      height: cardWidth / ratio,

      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            image: DecorationImage(
              image: AssetImage('assets/poker_back.jpg'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0)
            ]),
      ),
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
