import 'package:flame/flame_audio.dart';

class Audio {
  static FlameAudio audio = FlameAudio();

  static Future<void> load() async {
    audio.loadAll(["jump.ogg", "bgm.ogg", "start.ogg", "crashed.ogg"]);
  }

  static void playJump() {
    audio.play("jump.ogg");
  }

  static void playCrashed() {
    audio.play("crashed.ogg");
  }

  static void loopBGM() {
    audio.loopLongAudio("bgm.ogg");
  }

  static void playNewStart() {
    audio.play("start.ogg", volume: 0.8);
  }
}
