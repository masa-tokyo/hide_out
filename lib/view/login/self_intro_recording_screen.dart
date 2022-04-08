import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/uploading_page.dart';
import 'package:hide_out/view/recording/components/sub/recording_buttons.dart';
import 'package:hide_out/view_models/recording_view_model.dart';

class SelfIntroRecordingScreen extends StatelessWidget {
  final ProfileEditScreensOpenMode from;

  SelfIntroRecordingScreen({
    required this.from,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<RecordingViewModel, bool>(
      selector: (context, viewModel) => viewModel.isUploading,
      builder: (context, isUploading, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isUploading ? uploadingAppbarColor : null,
            title: Text("Self-Introduction"),
          ),
          body: Stack(children: [
            Center(
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
            isUploading ? UploadingPage() : Container(),
          ]),
        );
      },
    );
  }

  Widget _description() {
    return Column(
      children: [
        Text(
          "You can talk about:",
          style: selfIntroDescriptionTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "-Your name",
                style: selfIntroDescriptionTextStyle,
              ),
              Text(
                "-Where you are from",
                style: selfIntroDescriptionTextStyle,
              ),
              Text(
                "-What you do",
                style: selfIntroDescriptionTextStyle,
              ),
              Text(
                "-Your hobby, etc",
                style: selfIntroDescriptionTextStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}
