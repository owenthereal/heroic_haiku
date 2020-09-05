import 'package:flame/flame.dart';

class Audio {
  static Future<void> load() async {
    Flame.bgm.initialize();
    Flame.bgm.loadAll(["bgm.mp3"]);
    Flame.audio.loadAll(["jump.mp3", "start.mp3", "crashed.mp3"]);
  }

  static void playJump() {
    Flame.audio.play("jump.mp3");
  }

  static void playCrashed() {
    Flame.audio.play("crashed.mp3");
  }

  static void loopBGM() {
    Flame.bgm.play("bgm.mp3");
  }

  static void playNewStart() {
    Flame.audio.play("start.mp3", volume: 0.6);
  }
}
