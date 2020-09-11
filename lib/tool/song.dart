import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class SONG{
  static AudioPlayer player = new AudioPlayer();
  static void playBackgound(){
    player.play('assets/songs/beginning.mp3');
    player.onPlayerCompletion.listen((event) {
      print('finished');
    });
  }
}