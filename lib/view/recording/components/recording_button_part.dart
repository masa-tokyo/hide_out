import 'package:flutter/material.dart';
import 'package:voice_put/view/recording/components/sub/recording_buttons.dart';
import 'package:voice_put/view/recording/components/sub/recording_time_display.dart';

class RecordingButtonPart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingTimeDisplay(),
        RecordingButtons(),
      ],
    );
  }
}
