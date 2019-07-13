import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Music Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double playProgress = 24;
  @override
  Widget build(BuildContext context) {
    double componentWidth = MediaQuery.of(context).size.width / 1.4;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 20.0,
              child: new Container(
                width: componentWidth,
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset(
                  'assets/images/one.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Text(
              'Title',
              style: new TextStyle(
                color: Colors.black,
              ),
              textScaleFactor: 2.5,
            ),
            new Text(
              'Author',
              style: new TextStyle(
                color: Colors.blueAccent,
              ),
              textScaleFactor: 1.2,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.skip_previous),
                    iconSize: 50.0,
                    onPressed: null
                ),
                new IconButton(
                    icon: new Icon(Icons.play_arrow),
                    iconSize: 80.0,
                    onPressed: null
                ),
                new IconButton(
                    iconSize: 50.0,
                    icon: new Icon(Icons.skip_next),
                    onPressed: null
                ),
              ],
            ),
            new Container(
              width: componentWidth,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    '00:00',
                    style: new TextStyle(color: Colors.black),
                  ),
                  new Text(
                    '00:00',
                    style: new TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            new Container(
              width: componentWidth,
              height: 100.0,
              child: new Slider(
                value: playProgress,
                max: 100,
                divisions: 100,
                label: '0:00',
                onChanged: (double value){
                  setState(() {
                    playProgress = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
