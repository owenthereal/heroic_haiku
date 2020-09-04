import 'package:flame/flame.dart';

class Audio {
  static Future<void> load() async {
    Flame.bgm.initialize();
    Flame.bgm.loadAll(["bgm.ogg"]);
    Flame.audio.loadAll(["jump.ogg", "start.ogg", "crashed.ogg"]);
  }

  static void playJump() {
    Flame.audio.play("jump.ogg");
  }

  static void playCrashed() {
    Flame.audio.play("crashed.ogg");
  }

  static void loopBGM() {
    Flame.bgm.play("bgm.ogg");
  }

  static void playNewStart() {
    Flame.audio.play("start.ogg", volume: 0.6);
  }
}
