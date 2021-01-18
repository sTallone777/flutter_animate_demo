import 'package:flutter/material.dart';
import 'package:flutter_animate_demo/src/dealing.dart';
import 'package:flutter_animate_demo/src/drawimg.dart';
import 'package:flutter_animate_demo/src/thunderx.dart';

void main() => runApp(MyApp());

class Demo {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const Demo({this.name, this.route, this.builder});
}

final demos = [
  Demo(
    name: 'Dealing',
    route: Dealing.routeName,
    builder: (context) => Dealing(),
  ),
  Demo(
    name: 'ThunderX',
    route: ThunderX.routeName,
    builder: (context) => ThunderX(),
  ),
  Demo(
    name: 'DrawImage',
    route: DrawImg.routeName,
    builder: (context) => DrawImg(),
  ),
];

final demoRoutes = Map.fromEntries(demos.map((d) => MapEntry(d.route, d.builder)));

final allRoutes = <String, WidgetBuilder>{
  ...demoRoutes,
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: 'Animation Demos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: allRoutes,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme
        .of(context)
        .textTheme
        .headline6;
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Samples'),
      ),
      body: ListView(
          children: [
            // ListTile(title: Text('Basics', style: headerStyle)),
            ...demos.map((d) => DemoTile(d)),
          ]
      ),
    );
  }
}

class DemoTile extends StatelessWidget{
  final Demo demo;
  DemoTile(this.demo);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(demo.name),
        onTap: () {
          Navigator.pushNamed(context, demo.route);
        }
    );
  }
}
