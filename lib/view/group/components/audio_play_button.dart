import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view_models/group_view_model.dart';

class AudioPlayButton extends StatefulWidget {
  final String audioUrl;

  AudioPlayButton({@required this.audioUrl});

  @override
  _AudioPlayButtonState createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  AudioPlayButtonStatus _buttonStatus = AudioPlayButtonStatus.BEFORE_PLAYING;

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
    return Row(
      children: [
        _audioWidget(),
        //button
      ],
    );
  }

  Widget _audioWidget() {
    var play = false;
    return AudioWidget.network(
      url: widget.audioUrl,
      play: play,
      child: SizedBox(
        width: 5.0,
        height: 5.0,
        child: RaisedButton(
            child: Text(play
            ?"pause":"play"
            ),
            onPressed: (){
              setState(() {
                play = !play;
              });
            }),
      ),);
  }

  //---------------------------------------------------------------------------------------------- BEFORE_PLAYING

  Widget _beforePlayingButton() {
    return InkWell(
      onTap: () => _onBeforePlayingButtonPressed(),
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

  _onBeforePlayingButtonPressed() async {

    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);



    //todo if another audio is playing, pause it first

    // play audio
    await groupViewModel.playAudio(widget.audioUrl);

    setState(() {
      _buttonStatus = AudioPlayButtonStatus.DURING_PLAYING;
    });

  }

  //---------------------------------------------------------------------------------------------- DURING_PLAYING

  Widget _duringPlayingButton() {
    // return StreamBuilder<Object>(
    //     stream: null,
    //     builder: (context, snapshot) {
    //       return snapshot.hasData
    //           ? (snapshot == false)
    //           ? InkWell(
    //         onTap: () => _onDuringPlayingButtonPressed(),
    //         child: Card(
    //           elevation: 3.0,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(24.0)
    //           ),
    //           child: SizedBox(
    //             width: 36.0,
    //             height: 36.0,
    //             child:
    //             Icon(Icons.pause,
    //               size: 36.0,
    //               color: Colors.black54,),
    //           ),
    //         ),
    //       )
    //           : _beforePlayingButton()
    //           : Center(child: CircularProgressIndicator(),);
    //     }
    // );

    return Consumer<GroupViewModel>(builder: (context, model, child) {
      if (model.isAudioFinished) {
        return _beforePlayingButton();
      } else {
        return InkWell(
          onTap: () => _onDuringPlayingButtonPressed(),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: SizedBox(
              width: 36.0,
              height: 36.0,
              child: Icon(
                Icons.pause,
                size: 36.0,
                color: Colors.black54,
              ),
            ),
          ),
        );
      }
    });
    //todo erase this comment
    // return InkWell(
    //   onTap: () => _onDuringPlayingButtonPressed(),
    //   child: Card(
    //     elevation: 3.0,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(24.0)
    //     ),
    //     child: SizedBox(
    //       width: 36.0,
    //       height: 36.0,
    //       child:
    //       Icon(Icons.pause,
    //         size: 36.0,
    //         color: Colors.black54,),
    //     ),
    //   ),
    // );
  }

  _onDuringPlayingButtonPressed() async {
    print("pressed");

    //todo when another audio button became DURING_PLAYING, change this button's status to PAUSED or BEFORE_PLAYING

    //pause audio
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    await groupViewModel.pauseAudio();

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

  _onPausedButtonPressed() async {
    print("pressed");

    //resume audio
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    await groupViewModel.resumeAudio(widget.audioUrl);

    setState(() {
      _buttonStatus = AudioPlayButtonStatus.DURING_PLAYING;
    });
  }


}
