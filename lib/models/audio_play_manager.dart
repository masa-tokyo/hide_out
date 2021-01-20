import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayManager{

  AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();

  Future<void> prepareAudio(String audioUrl) async{
    try {
      await _audioPlayer.open(
        Audio.liveStream(audioUrl),
      );
    } catch (e){
      print("error: $e");
    }
  }

  Future<void> playAudio() async{
    try{
      _audioPlayer.play();
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> pauseAudio() async{
    try{
      _audioPlayer.pause();
    } catch (e) {
      print("error: $e");
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}