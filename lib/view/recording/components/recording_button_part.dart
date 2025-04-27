import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/view/recording/components/sub/recording_buttons.dart';

class RecordingButtonPart extends StatelessWidget {
  final RecordingButtonOpenMode from;
  final Group? group;

  RecordingButtonPart({required this.from, required this.group});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RecordingButtons(from: from, group: group,),
      ],
    );
  }
}
