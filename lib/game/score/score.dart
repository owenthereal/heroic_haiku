import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:heroic_haiku/game/score/score_config.dart';

class Score extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Image spriteImage;

  Score(this.spriteImage) : super();

  void updateScore(double t) {
    components.clear();

    final s = t.toStringAsFixed(0);
    for (int i = 0; i < s.length; i++) {
      final scoreText = ScoreText(spriteImage, int.parse(s[i]));
      scoreText.x = size.width -
          (ScoreConfig.digitWidth + ScoreConfig.digitSpace) *
              (s.length + 1 - i);
      scoreText.y = 20;

      components.add(scoreText);
    }
  }
}

class ScoreText extends SpriteComponent with Resizable {
  ScoreText(Image spriteImage, int n)
      : super.fromSprite(
          ScoreConfig.digitWidth,
          ScoreConfig.digitHeight,
          Sprite.fromImage(
            spriteImage,
            x: 955.0 + (ScoreConfig.digitWidth + ScoreConfig.digitSpace) * n,
            y: 0.0,
            width: ScoreConfig.digitWidth,
            height: ScoreConfig.digitHeight,
          ),
        );
}
