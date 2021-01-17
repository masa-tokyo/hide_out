import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingTimeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);

    return recordingViewModel.stopwatchController.stream == null
        ? Text("00:00 p1")
        : StreamBuilder<String>(
            stream: recordingViewModel.stopwatchController.stream,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return snapshot.hasData ? Text(snapshot.data) : Text("00:00 p2");
            });
  }
}
