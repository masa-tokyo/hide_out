import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayManager extends ChangeNotifier{

  AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  List<StreamSubscription> _subscriptions = [];

  bool _isAudioFinished = false;
  bool get isAudioFinished => _isAudioFinished;



  Future<void> playAudio(String audioUrl) async{
    try{

      await _audioPlayer.open(
        Audio.liveStream(audioUrl),
      );
      _audioPlayer.play();


      _subscriptions.add(_audioPlayer.isPlaying.listen((event) {
        print("isPlaying: $event");
      }));
      _subscriptions.add(_audioPlayer.playlistFinished.listen((event) {
        print("playlistFinished: $event");
        _isAudioFinished = event;
       notifyListeners();

        if(_isAudioFinished) {
          _isAudioFinished = false;
          print("_isAudioFinished: $_isAudioFinished");
          notifyListeners();
        }

      }));



      // AssetsAudioPlayer.playAndForget(
      //   Audio.liveStream(audioUrl),
      // );

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