import 'package:flutter/material.dart';

import 'components/journal_description_part.dart';
import 'components/journal_timer_part.dart';


class AudioJournalScreen extends StatelessWidget {
  final String questionString1;
  final String questionString2;
  final String questionString3;
  final Widget screen;
  final Widget icon;
  final String titleString;

  AudioJournalScreen({@required this.questionString1, @required this.screen, @required this.icon, this.questionString2, this.questionString3, @required this.titleString});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: icon,
            onPressed: () => Navigator.pop(context)),
        title: Text(titleString),
        actions: [
          TextButton(
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
              child: JournalDescriptionPart(questionString1: questionString1, questionString2: questionString2, questionString3: questionString3,),
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
