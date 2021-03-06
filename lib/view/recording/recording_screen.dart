import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/dialog/confirm_dialog.dart';
import 'package:voice_put/view/recording/components/post_description_part.dart';
import 'package:voice_put/view/recording/components/recording_button_part.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingScreen extends StatelessWidget {
  final String noteText;

  RecordingScreen({@required this.noteText});

  @override
  Widget build(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () => _unFocusKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          leading: _backButton(context),
          title: Consumer<RecordingViewModel>(
            builder: (context, model, child) {
              return model.isTyping ? Container() : Text("New Recording");
            },
          ),
          actions: [
            Consumer<RecordingViewModel>(builder: (context, model, child) {
              return model.isTyping
                  ? FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        recordingViewModel.updateForNotTyping();
                      },
                      child: Icon(Icons.keyboard_arrow_down),
                    )
                  : Container();
            }),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PostDescriptionPart(
              noteText: noteText,
            ),
            RecordingButtonPart(),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);

    return IconButton(
        icon: Icon(
          Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        ),
        onPressed: () {
          if (recordingViewModel.recordingButtonStatus == RecordingButtonStatus.DURING_RECORDING ||
              recordingViewModel.recordingButtonStatus == RecordingButtonStatus.AFTER_RECORDING) {
            showConfirmDialog(
              context: context,
              titleString: "Quit Recording?",
              contentString: "If you tap 'Discard', you will lose the data.",
              onConfirmed: (isConfirmed) async {
                if (isConfirmed) {
                  Navigator.pop(context);
                  await recordingViewModel
                      .updateRecordingButtonStatus(RecordingButtonStatus.BEFORE_RECORDING);
                }
              },
              yesText: Text(
                "Discard",
                style: showConfirmDialogYesTextStyle,
              ),
              noText: Text(
                "Cancel",
                style: showConfirmDialogNoTextStyle,
              ),
            );
          } else {
            recordingViewModel.updateForNotTyping();
            Navigator.pop(context);
          }
        });
  }

  _unFocusKeyboard(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
      recordingViewModel.updateForNotTyping();
    }
  }
}
