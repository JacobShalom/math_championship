// Dart Program to add 3D objects to your project

// importing material.dart
import 'package:flutter/material.dart';

// importing flutter cube package
import 'package:flutter_cube/flutter_cube.dart';

// creating class of stateful widget
class HomePage extends StatefulWidget {
  //MyHomePage
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState(); //_MyHomePageState
}

class _HomePageState extends State<HomePage> {
  // adding necessary objects
  late Object earth;
  late Object astro;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    earth = Object(fileName: "assets/earth/earth_ball.obj");
    astro = Object(fileName: "assets/Astronaut/Astronaut.obj");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          children: [
            Expanded(
              child: Text(
                'You have pushed the button this many times:$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(
              child: Cube(
                onSceneCreated: (Scene scene) {
                  scene.world.add(earth);
                  scene.camera.zoom = 10;
                },
              ),
            ),
            Expanded(
              child: Cube(
                onSceneCreated: (Scene scene) {
                  scene.world.add(astro);
                  scene.camera.zoom = 10;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
