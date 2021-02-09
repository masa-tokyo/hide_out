import 'package:flutter/material.dart';


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
            //todo go to next screen
              onPressed: null,
              child: Text("Skip")),
        ],
      ),
      body: Column(
        children: [
          //JournalDescriptionPart(),
          //todo
          //JournalTimerPart(),
        ],
      ),
    );
  }
}
