import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';


class JournalTimerPart extends StatefulWidget {
  final Widget screen;

  JournalTimerPart({@required this.screen});

  @override
  _JournalTimerPartState createState() => _JournalTimerPartState();
}

class _JournalTimerPartState extends State<JournalTimerPart> {
  bool _isSpeaking = false;
  Timer _timer;
  int _intTime = 60;



  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); //todo erase this when skip button becomes able to cancel the timer
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _timeDisplay(),
        SizedBox(height: 64.0,),
        _audioJournalButton()
      ],
    );
  }

  Widget _timeDisplay() {

    var duration = Duration(
      seconds:_intTime
    );

    return Text(_calculatedDurationString(duration),
      style: timeDisplayTextStyle,);
  }

  String _calculatedDurationString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
  }


  Widget _audioJournalButton() {
    return _isSpeaking
    ? _duringSpeakingButton()
    : _beforeSpeakingButton();
  }

  //----------------------------------------------------------------------------------------------------- before speaking

  _beforeSpeakingButton() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: RaisedButton(
        child: Text("Speak", style: audioJournalButtonTextStyle,),
        onPressed: () => _onBeforeSpeakingButtonPressed(context),
        elevation: 2.0,
        color: Colors.white30,
        shape: CircleBorder(
        ),
      ),
    );

  }


  _onBeforeSpeakingButtonPressed(BuildContext context) {
    //todo start countdown
    _startTimer();

    setState(() {
      _isSpeaking = true;
    });
  }

  void _startTimer() {
    final oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec,
            (timer) {
      if(_intTime == 0){
        setState(() {
          timer.cancel();
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget.screen));

        });
      } else {
        setState(() {
          _intTime--;
        });
      }
            });
  }


  //----------------------------------------------------------------------------------------------------- during speaking

  _duringSpeakingButton() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: RaisedButton(
        child: Text("Finish", style: audioJournalButtonTextStyle,),
        onPressed: () => _onDuringSpeakingButtonPressed(context),
        elevation: 2.0,
        color: Colors.white30,
        shape: CircleBorder(
        ),
      ),
    );
  }


  _onDuringSpeakingButtonPressed(BuildContext context) async{
    //stop countdown
    _timer.cancel();

    await Navigator.push(context, MaterialPageRoute(builder: (_) => widget.screen));

    setState(() {
      _isSpeaking = false;
      _intTime = 60;
    });


  }




}
