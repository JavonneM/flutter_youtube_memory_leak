import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: 'By_Cn5ixYLg',
      params: const YoutubePlayerParams(
        autoPlay: false,
        showControls: true,
        showFullscreenButton: true,
        enableCaption: false,
        strictRelatedVideos: true,
        desktopMode: false,
      ),
      // ignore: always_specify_types
    )..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            ..hideTopMenu();
        }
      });
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      debugPrint('Entered Fullscreen');
    };

    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]);

      Future<void>.delayed(const Duration(seconds: 5), () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      });

      debugPrint('Exited Fullscreen');
    };
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    InAppWebView(
                      initialOptions: InAppWebViewGroupOptions(
                        // android: AndroidInAppWebViewOptions(),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                        ),
                        crossPlatform: InAppWebViewOptions(
                          disableHorizontalScroll: true,
                          disableVerticalScroll: true,
                          mediaPlaybackRequiresUserGesture: false,
                        ),
                      ),
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            'https://media3.giphy.com/media/BZity0rWNCMSsSIRXK/giphy.gif?cid=ecf05e4734d03cab8d2ad84b73d1001ebc3104457eefd116&rid=giphy.gif&ct=s'),
                      ),
                      onLoadStop: (InAppWebViewController controller,
                          Uri? url) async {},
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            YoutubePlayerIFrame(
              controller: _controller,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
