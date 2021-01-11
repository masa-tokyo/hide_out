import 'package:flutter/material.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/recording/components/sub/after_recording_buttons.dart';
import 'package:voice_put/view/recording/components/sub/before_recording_button.dart';
import 'package:voice_put/view/recording/components/sub/during_recording_button.dart';
import 'package:voice_put/view/recording/components/sub/recording_time_display.dart';

class RecordingButtonPart extends StatelessWidget {
  final recordingScreenType = RecordingScreenType.AFTER_RECORDING;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecordingTimeDisplay(),
        _recordingButtons(context, recordingScreenType),
      ],
    );
  }

  Widget _recordingButtons(BuildContext context, RecordingScreenType recordingScreenType) {
    var button;
    switch(recordingScreenType){
      case RecordingScreenType.BEFORE_RECORDING:
        button = BeforeRecordingButton();
        break;
      case RecordingScreenType.DURING_RECORDING:
        button = DuringRecordingButton();
        break;
      case RecordingScreenType.AFTER_RECORDING:
        button = AfterRecordingButtons();
        break;
    }
    return button;

  }
}
