import 'package:flutter/material.dart';

import 'components/journal_description_part.dart';
import 'components/journal_timer_part.dart';


class AudioJournalScreen extends StatelessWidget {
  final String questionString;
  final Widget screen;
  final Widget icon;

  AudioJournalScreen({@required this.questionString, @required this.screen, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: icon,
            onPressed: () => Navigator.pop(context)),
        title: Text("Audio Journal"),
        actions: [
          FlatButton(
              onPressed: () => _openNextScreen(context),
              child: Text("Skip")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: JournalDescriptionPart(questionString: questionString,),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 52.0),
              child: JournalTimerPart(screen: screen,),
            ),
          ],
        ),
      ),
    );
  }

  _openNextScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));


  }
}
