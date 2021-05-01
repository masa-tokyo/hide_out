
import 'package:flutter/material.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/components/sub/recording_buttons.dart';

class SelfIntroRecordingScreen extends StatelessWidget {
  final ProfileEditScreensOpenMode from;

  SelfIntroRecordingScreen({@required this.from,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self-Introduction"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _description(),
            RecordingButtons(
                from: from == ProfileEditScreensOpenMode.PROFILE
                ? RecordingButtonOpenMode.SELF_INTRO_FROM_PROFILE
                : RecordingButtonOpenMode.SELF_INTRO_FROM_SIGN_UP,
                group: null),
            ],
        ),
      ),
    );
  }

  Widget _description() {
    return Column(
      children: [
        Text("You can talk about:", style: selfIntroDescriptionTextStyle,),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-Your name", style: selfIntroDescriptionTextStyle,),
              Text("-Where you are from", style: selfIntroDescriptionTextStyle,),
              Text("-What you do", style: selfIntroDescriptionTextStyle,),
              Text("-Your hobby, etc", style: selfIntroDescriptionTextStyle,),
            ],
          ),
        )
      ],
    );
  }
}
