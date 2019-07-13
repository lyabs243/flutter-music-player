import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'audio.dart';
import 'package:audioplayer/audioplayer.dart';

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
        accentTextTheme: TextTheme(body2: TextStyle(color: Colors.black)),
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

  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription stateSub;
  Duration position = new Duration(seconds: 0);
  Duration duration = new Duration(seconds: 0);
  AudioPlayerState status = AudioPlayerState.STOPPED;

  List<Audio> audioList = [
    new Audio('Audio 1', 'Author 1', 'assets/images/one.jpg', 'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    new Audio('Audio 2', 'Author 2', 'assets/images/two.jpg', 'https://codabee.com/wp-content/uploads/2018/06/deux.mp3'),
  ];
  Audio currentAudio;

  @override
  initState() {
    super.initState();
    currentAudio = audioList[0];
    configAudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

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
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[800],
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
                  currentAudio.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Text(
              currentAudio.title,
              style: new TextStyle(
                color: Colors.white,
              ),
              textScaleFactor: 2.5,
            ),
            new Text(
              currentAudio.author,
              style: new TextStyle(
                color: Colors.white,
              ),
              textScaleFactor: 1.2,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.fast_rewind),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: (){

                    }
                ),
                new IconButton(
                    icon: new Icon((status == AudioPlayerState.PLAYING)? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                    iconSize: 80.0,
                    onPressed: (){
                      setState(() {
                        if(status == AudioPlayerState.PLAYING){
                          pause();
                        }
                        else{
                          play();
                        }
                      });
                    }
                ),
                new IconButton(
                    icon: new Icon(Icons.fast_forward),
                    iconSize: 50.0,
                    color: Colors.white,
                    onPressed: (){

                    }
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
                    style: new TextStyle(color: Colors.white),
                  ),
                  new Text(
                    '00:00',
                    style: new TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            new Container(
              width: componentWidth,
              height: 100.0,
              child: new Slider(
                value: position.inSeconds.toDouble(),
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                max: (duration.inSeconds.toDouble() > 0)? duration.inSeconds.toDouble(): 0,
                divisions: (duration.inSeconds.toInt() > 0)? duration.inSeconds.toInt() : 5,
                label: '0:00',
                onChanged: (double value){
                  setState(() {
                    position = new Duration(seconds: value.toInt());
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future play() async
  {
    status = AudioPlayerState.PLAYING;
    //await audioPlayer.seek((position != null)? position.inSeconds.toDouble() : 0);
    await audioPlayer.play(currentAudio.audioPath);
  }

  Future pause() async
  {
    status = AudioPlayerState.PAUSED;
    await audioPlayer.pause();
  }

  void configAudioPlayer(){
    audioPlayer = new AudioPlayer();
    
    positionSub = audioPlayer.onAudioPositionChanged.listen(
        (pos) => setState(() => position = pos),
    );

    stateSub = audioPlayer.onPlayerStateChanged.listen((state){
      status = state;
      if(state == AudioPlayerState.PLAYING)
      {
        duration = audioPlayer.duration;
      }
    },
    onDone: (){
      setState(() {
        position = new Duration(seconds: 0);
        status = AudioPlayerState.STOPPED;
      });
    },
    onError: (message){
      print('Erreur: $message');
      setState(() {
        status = AudioPlayerState.STOPPED;
      });
    });
  }
}
