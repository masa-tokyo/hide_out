import 'package:flutter/material.dart';
import 'package:voice_put/view/recording/preparation_note_screen.dart';

import 'components/journal_description_part.dart';
import 'components/journal_timer_part.dart';


class AudioJournalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
        title: Text("Audio Journal"),
        actions: [
          FlatButton(
              onPressed: () => _openPreparationNoteScreen(context),
              child: Text("Skip")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: JournalDescriptionPart(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 52.0),
              child: JournalTimerPart(),
            ),
          ],
        ),
      ),
    );
  }

  _openPreparationNoteScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PreparationNoteScreen()));


  }
}
