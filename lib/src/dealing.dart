import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class Dealing extends StatefulWidget {
  static String routeName = '/dealing';
  Dealing({Key key}) : super(key: key);

  @override
  _DealingState createState() => _DealingState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _DealingState extends State<Dealing>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // _controller.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     _controller.reverse();
    //   }else if(status == AnimationStatus.dismissed){
    //     _controller.forward();
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: RaisedButton(
                  child: Text('Go', style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    _controller.forward();
                  },
                ),
              ),
              CustomCard(
                controller: _controller,
                lb: 100,
                le: 10,
                tb: 700,
                te: 10,
                li1: 0.0,
                li2: 0.5,
              ),
              CustomCard(
                controller: _controller,
                lb: 200,
                le: 100,
                tb: 700,
                te: 10,
                li1: 0.5,
                li2: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({ Key key, this.controller, this.lb, this.le, this.tb, this.te, this.li1, this.li2 }): super(key: key){

    left = Tween<double>(
      begin: lb,
      end: le,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          li1, li2, //间隔，后40%的动画时间
          curve: Curves.linear,
        ),
      ),
    );

    top = Tween<double>(
      begin: tb,
      end: te,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          li1, li2, //间隔，后40%的动画时间
          curve: Curves.linear,
        ),
      ),
    );
  }


  final Animation<double> controller;
  double lb, le, tb, te, li1, li2;
  Animation<double> left;
  Animation<double> top;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      left: left.value,
      top: top.value,
      width: 60,
      height: 80,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            color: Colors.deepOrangeAccent,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0)
            ]
        ),
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
