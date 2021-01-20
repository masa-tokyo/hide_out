import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/recording/components/sub/recording_buttons.dart';
import 'package:voice_put/view/recording/components/sub/recording_time_display.dart';

class RecordingButtonPart extends StatelessWidget {
  final Group group;

  RecordingButtonPart({@required this.group});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingTimeDisplay(),
        RecordingButtons(group: group,),
      ],
    );
  }
}
