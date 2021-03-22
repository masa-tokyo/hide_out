import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/recording/components/sub/recording_buttons.dart';

class RecordingButtonPart extends StatelessWidget {
  final RecordingOpenMode from;
  final Group group;

  RecordingButtonPart({@required this.from, @required this.group});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingButtons(from: from, group: group,),
      ],
    );
  }
}
