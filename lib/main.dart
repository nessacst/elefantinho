import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elefante',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Vamos brincar!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 1;

  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onDurationChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    // String url =
    // 'https://servidor.geracaoradios.com/listen/kids/stream?1661626376492';
    // audioPlayer.setUrl(url);

    /// Carregar audio local
    final player = AudioCache(prefix: 'assets/sound/');
    final url = await player.load('fantinho.mp3');
    audioPlayer.setUrl(url.path, isLocal: true);
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  var palavra = [];

  mudaFrase() {
    for (var i = counter; i <= counter; i++) {
      palavra.add("$i - incomodam");
    }
    if (counter <= 1) {
      return '$counter elefante incomoda muita gente';
    } else if (counter > 1 && counter % 2 == 0) {
      return '$counter elefantes ${palavra.toList()} muito mais';
    } else if (counter > 1 && counter % 2 != 0) {
      return '$counter elefantes incomodam muita gente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (isPlaying) {
                audioPlayer.pause();
              } else {
                await audioPlayer.resume();
              }
              //==============
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Cante!')));
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.music_note_rounded,
            ),
            tooltip: 'Music',
          )
        ],
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Clique no botão + e brinque junto comigo :)',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/images/elefante.png',
                    width: 300, height: 300, fit: BoxFit.fill),
                Image.asset('assets/images/music.png',
                    width: 100, height: 100, fit: BoxFit.fill),
                Text(
                  mudaFrase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
