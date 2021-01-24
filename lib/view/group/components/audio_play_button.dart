import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayButton extends StatefulWidget {
  final String audioUrl;

  AudioPlayButton({@required this.audioUrl});

  @override
  _AudioPlayButtonState createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  bool _isPlaying = false;


  @override
  Widget build(BuildContext context) {
    return _audioWidget();
  }

  Widget _audioWidget() {
        return AudioWidget.network(
          url: widget.audioUrl,
          play: _isPlaying,
          loopMode: LoopMode.single,
          child: !_isPlaying
              ? _notPlayingButton()
              : _duringPlayingButton(),
          onFinished: () => _onAudioFinished(),
        );
  }


  _onButtonPressed(){
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  _onAudioFinished(){
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  //------------------------------------------------------------------------------------------------- NOT_PLAYING

  Widget _notPlayingButton() {
    return InkWell(
      onTap: () => _onButtonPressed(),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child: Icon(
            Icons.play_arrow,
            size: 36.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }


  //-------------------------------------------------------------------------------------------------DURING_PLAYING

  Widget _duringPlayingButton() {

    return InkWell(
      onTap: () => _onButtonPressed(),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0)
        ),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child:
          Icon(Icons.pause,
            size: 36.0,
            color: Colors.black54,),
        ),
      ),
    );
  }

}
