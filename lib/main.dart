import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/services.dart';

import 'package:heroic_haiku/game/game.dart';
import 'package:heroic_haiku/game/audio/audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.util.setLandscape();
  await Flame.util.fullScreen();
  await Audio.load();

  runApp(MaterialApp(
    title: 'Heroic Haiku',
    color: Colors.white,
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: GameWrapper(),
    ),
  ));
}

class GameWrapper extends StatefulWidget {
  @override
  _GameWrapperState createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  bool splashGone = false;
  Game game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.load("sprite.png").then((image) => {
          setState(() {
            game = Game(spriteImage: image);
            _focusNode.requestFocus();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return splashGone ? _buildGame(context) : _buildLogo(context);
  }

  Widget _buildLogo(BuildContext context) {
    WidgetBuilder _logoBuilder = (context) => Image(
          width: 300,
          image: AssetImage(
            'assets/images/heroic_haiku.gif',
          ),
        );
    return FlameSplashScreen(
      theme: FlameSplashTheme.white,
      showBefore: _logoBuilder,
      onFinish: (context) {
        setState(() {
          splashGone = true;
        });
      },
    );
  }

  Widget _buildGame(BuildContext context) {
    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }

    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: Container(
          child: RawKeyboardListener(
        key: ObjectKey("game"),
        child: game.widget,
        focusNode: _focusNode,
        onKey: _onRawKeyEvent,
      )),
    );
  }

  void _onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      game.onAction();
    }
  }
}
