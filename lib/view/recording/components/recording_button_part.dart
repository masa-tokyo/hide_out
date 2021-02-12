import 'package:flutter/material.dart';
import 'package:voice_put/view/recording/components/sub/recording_buttons.dart';

class RecordingButtonPart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingButtons(),
      ],
    );
  }
}
