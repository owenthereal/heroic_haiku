import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:heroic_haiku/game/horizon/horizon.dart';
import 'package:heroic_haiku/game/collision/collision_utils.dart';
import 'package:heroic_haiku/game/game_config.dart';
import 'package:heroic_haiku/game/game_over/game_over.dart';
import 'package:heroic_haiku/game/ninja/config.dart';
import 'package:heroic_haiku/game/ninja/ninja.dart';
import 'package:heroic_haiku/game/audio/audio.dart';

class Background extends Component with Resizable {
  Background();

  final Paint _paint = Paint()..color = const Color(0xffffffff);

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {}
}

enum GameStatus { playing, waiting, gameOver }

class Game extends BaseGame with MultiTouchTapDetector, HasTapableComponents {
  Game({Image spriteImage}) {
    ninja = Ninja(spriteImage);
    horizon = Horizon(spriteImage);
    gameOverPanel = GameOverPanel(spriteImage);

    this..add(Background())..add(horizon)..add(ninja)..add(gameOverPanel);
  }

  Ninja ninja;
  Horizon horizon;
  GameOverPanel gameOverPanel;
  GameStatus status = GameStatus.waiting;

  double currentSpeed = GameConfig.speed;

  @override
  void onTapDown(_, __) {
    onAction();
  }

  void onAction() {
    if (gameOver) {
      restart();
      return;
    }

    ninja.startJump(currentSpeed);
  }

  @override
  void update(double t) {
    super.update(t);

    ninja.update(t);
    horizon.updateWithSpeed(0.0, currentSpeed);

    if (gameOver) {
      return;
    }

    if (ninja.playingIntro && ninja.x >= NinjaConfig.startXPos) {
      startGame();
    } else if (ninja.playingIntro) {
      horizon.updateWithSpeed(0.0, currentSpeed);
    }

    if (playing) {
      horizon.updateWithSpeed(t, currentSpeed);

      final obstacles = horizon.horizonLine.obstacleManager.components;
      final hasCollision =
          obstacles.isNotEmpty && checkForCollision(obstacles.first, ninja);
      if (!hasCollision) {
        if (currentSpeed < GameConfig.maxSpeed) {
          currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
    ninja.status = NinjaStatus.running;
    status = GameStatus.playing;
    ninja.hasPlayedIntro = true;
    Audio.loopBGM();
    Audio.playNewStart();
  }

  bool get playing => status == GameStatus.playing;
  bool get gameOver => status == GameStatus.gameOver;

  void doGameOver() {
    gameOverPanel.visible = true;
    status = GameStatus.gameOver;
    ninja.status = NinjaStatus.crashed;
    Audio.playCrashed();
  }

  void restart() {
    status = GameStatus.playing;
    ninja.reset();
    horizon.reset();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    Audio.playNewStart();
  }
}
