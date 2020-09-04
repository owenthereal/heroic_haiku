import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:heroic_haiku/game/ninja/config.dart';
import 'package:heroic_haiku/game/audio/audio.dart';

enum NinjaStatus { crashed, jumping, running, waiting, intro }

class Ninja extends PositionComponent with Resizable {
  Ninja(Image spriteImage)
      : runningNinja = RunningNinja(spriteImage),
        waitingNinja = WaitingNinja(spriteImage),
        jumpingNinja = JumpingNinja(spriteImage),
        crashedNinja = CrashedNinja(spriteImage),
        super();

  NinjaStatus _status = NinjaStatus.waiting;

  NinjaStatus get status => _status;
  set status(NinjaStatus status) {
    _status = status;
    position.x = x;
    position.y = y;
  }

  WaitingNinja waitingNinja;
  RunningNinja runningNinja;
  JumpingNinja jumpingNinja;
  CrashedNinja crashedNinja;

  double jumpVelocity = 0.0;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  PositionComponent get position {
    switch (status) {
      case NinjaStatus.waiting:
        return waitingNinja;
      case NinjaStatus.jumping:
        return jumpingNinja;
      case NinjaStatus.crashed:
        return crashedNinja;
      case NinjaStatus.intro:
      case NinjaStatus.running:
      default:
        return runningNinja;
    }
  }

  void startJump(double speed) {
    if (status == NinjaStatus.jumping) {
      return;
    }

    status = NinjaStatus.jumping;
    jumpVelocity = NinjaConfig.initialJumpVelocity - (speed / 10);
    Audio.playJump();
  }

  @override
  void render(Canvas c) {
    if (size == null) {
      return;
    }
    position.render(c);
  }

  void reset() {
    position.y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = NinjaStatus.running;
  }

  @override
  void update(double t) {
    super.update(t);

    if (status == NinjaStatus.jumping) {
      y += jumpVelocity;
      jumpVelocity += NinjaConfig.gravity;
      if (y > groundYPos) {
        reset();
        jumpCount++;
      }
    } else {
      y = groundYPos;
    }

    // adjust initial position
    if (x < NinjaConfig.startXPos) {
      x = NinjaConfig.startXPos;
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) {
      status = NinjaStatus.intro;
    }
    if (playingIntro && x < NinjaConfig.startXPos) {
      x += (NinjaConfig.startXPos / NinjaConfig.introDuration) * t * 5000;
    }

    position.x = x;
    position.y = y;
    position.update(t);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    position.y = groundYPos;
  }

  double get groundYPos {
    if (size == null) {
      return null;
    }
    return (size.height / 2) - NinjaConfig.height / 2;
  }

  bool get playingIntro => status == NinjaStatus.intro;
  bool get crashed => status == NinjaStatus.crashed;
  bool get jumping => status == NinjaStatus.jumping;
}

class RunningNinja extends AnimationComponent {
  RunningNinja(Image spriteImage)
      : super(
          NinjaConfig.width,
          NinjaConfig.height,
          Animation.spriteList(
            [
              Sprite.fromImage(
                spriteImage,
                width: 146,
                height: 94,
                y: 4.0,
                x: 1780.0,
              ),
              Sprite.fromImage(
                spriteImage,
                width: 113,
                height: 94,
                y: 4.0,
                x: 1926.0,
              ),
            ],
            stepTime: 0.2,
            loop: true,
          ),
        );
}

class WaitingNinja extends SpriteComponent {
  WaitingNinja(Image spriteImage)
      : super.fromSprite(
          NinjaConfig.width,
          NinjaConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: 110,
            height: 108,
            x: 2280.0,
            y: 2.0,
          ),
        );
}

class JumpingNinja extends SpriteComponent {
  JumpingNinja(Image spriteImage)
      : super.fromSprite(
          NinjaConfig.width,
          NinjaConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: 113,
            height: 69,
            x: 1581.0,
            y: 5.0,
          ),
        );
}

class CrashedNinja extends SpriteComponent {
  CrashedNinja(Image spriteImage)
      : super.fromSprite(
          NinjaConfig.width,
          NinjaConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: 81,
            height: 105,
            x: 1698.0,
            y: 4.0,
          ),
        );
}
