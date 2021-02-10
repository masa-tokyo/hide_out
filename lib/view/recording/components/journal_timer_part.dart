import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:voice_put/utils/style.dart';

class JournalTimerPart extends StatefulWidget {
  @override
  _JournalTimerPartState createState() => _JournalTimerPartState();
}

class _JournalTimerPartState extends State<JournalTimerPart> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));

    super.initState();
  }

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
    //todo
    return Text("button");
  }

}
