import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:voice_put/utils/style.dart';

import '../preparation_note_screen.dart';

class JournalTimerPart extends StatefulWidget {
  @override
  _JournalTimerPartState createState() => _JournalTimerPartState();
}

class _JournalTimerPartState extends State<JournalTimerPart> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _isSpeaking = false;

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _timeDisplay(),
        SizedBox(height: 8.0,),
        _audioJournalButton()
      ],
    );
  }

  Widget _timeDisplay() {
    return StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snapshot) {
          return Text(StopWatchTimer.getDisplayTime(
              snapshot.data,
              hours: snapshot.data < 3600000
                  ? false
                  : true,
              milliSecond: false),
            style: timeDisplayTextStyle,);
        }
    );

  }

  Widget _audioJournalButton() {
    return _isSpeaking
    ? _duringSpeakingButton()
    : _beforeSpeakingButton();
  }

  //----------------------------------------------------------------------------------------------------- before speaking

  _beforeSpeakingButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardCircle(context),
      ],
    );
  }

  Widget _backwardCircle() {
    return  Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _forwardCircle(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      child: RaisedButton(
        onPressed: () => _onCircleButtonPressed(context),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: CircleBorder(
        ),
      ),
    );
  }
  _onCircleButtonPressed(BuildContext context) {
    //start stopwatch
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    setState(() {
      _isSpeaking = true;
    });
  }

  //----------------------------------------------------------------------------------------------------- during speaking

  _duringSpeakingButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardRectangle(context),
      ],
    );

  }

  _forwardRectangle(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: RaisedButton(
        onPressed: () => _onRectangleButtonPressed(context),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );

  }

  _onRectangleButtonPressed(BuildContext context) async{

    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);

    setState(() {
      _isSpeaking = false;
    });

    await Navigator.push(context, MaterialPageRoute(builder: (_) => PreparationNoteScreen()));

    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);

  }


}
