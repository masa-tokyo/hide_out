import 'package:flutter/material.dart';
import 'package:voice_put/utils/constants.dart';

class AudioPlayButton extends StatefulWidget {
 // final String audioPath

  @override
  _AudioPlayButtonState createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  AudioPlayButtonStatus _buttonStatus = AudioPlayButtonStatus.BEFORE_PLAYING;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var button;
    switch (_buttonStatus) {
      case AudioPlayButtonStatus.BEFORE_PLAYING:
        button = _beforePlayingButton();
        break;
      case AudioPlayButtonStatus.DURING_PLAYING:
        button = _duringPlayingButton();
        break;
      case AudioPlayButtonStatus.PAUSED:
        button = _pausedButton();
        break;
    }
    return button;
  }

  //---------------------------------------------------------------------------------------------- BEFORE_PLAYING

  Widget _beforePlayingButton() {
    return InkWell(
      onTap: () => _onBeforePlayingButtonPressed(),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0)
        ),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child:
          Icon(Icons.play_arrow,
            size: 36.0,
            color: Colors.black54,),
        ),
      ),
    );
  }

  _onBeforePlayingButtonPressed() {
    print("pressed");
    //todo play audio

    setState(() {
      _buttonStatus = AudioPlayButtonStatus.DURING_PLAYING;
    });

    //todo when finished, change the status to BEFORE_PLAYING again

  }

  //---------------------------------------------------------------------------------------------- DURING_PLAYING

  Widget _duringPlayingButton() {
    return InkWell(
      onTap: () => _onDuringPlayingButtonPressed(),
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

  _onDuringPlayingButtonPressed() {
    print("pressed");

    //todo when another audio button became DURING_PLAYING, change this button's status to PAUSED or BEFORE_PLAYING

    //todo pause audio

    setState(() {
      _buttonStatus = AudioPlayButtonStatus.PAUSED;
    });
  }


//---------------------------------------------------------------------------------------------- PAUSED

  Widget _pausedButton() {
    return InkWell(
      onTap: () => _onPausedButtonPressed(),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0)
        ),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child:
          Icon(Icons.play_arrow,
            size: 36.0,
            color: Colors.black54,),
        ),
      ),
    );
  }

  _onPausedButtonPressed() {
    print("pressed");

    //todo re-start audio

    setState(() {
      _buttonStatus = AudioPlayButtonStatus.DURING_PLAYING;
    });
  }

}