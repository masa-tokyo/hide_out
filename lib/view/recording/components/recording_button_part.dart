import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/recording/components/sub/after_recording_buttons.dart';
import 'package:voice_put/view/recording/components/sub/before_recording_button.dart';
import 'package:voice_put/view/recording/components/sub/during_recording_button.dart';
import 'package:voice_put/view/recording/components/sub/recording_time_display.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingButtonPart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingTimeDisplay(),
        Selector<RecordingViewModel, RecordingButtonStatus>(
            selector: (context, viewModel) => viewModel.recordingButtonStatus,
            builder: (context, status, child) => _recordingButtons(context, status),
            ),
      ],
    );
  }

  Widget _recordingButtons(BuildContext context, RecordingButtonStatus status) {
    var button;
    switch(status){
      case RecordingButtonStatus.BEFORE_RECORDING:
        button = BeforeRecordingButton();
        break;
      case RecordingButtonStatus.DURING_RECORDING:
        button = DuringRecordingButton();
        break;
      case RecordingButtonStatus.AFTER_RECORDING:
        button = AfterRecordingButtons();
        break;
    }
    return button;

  }
}
