import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/confirm_dialog.dart';
import 'package:hide_out/view/recording/components/post_description_part.dart';
import 'package:hide_out/view/recording/components/recording_button_part.dart';
import 'package:hide_out/view_models/recording_view_model.dart';

class RecordingScreen extends StatelessWidget {
  final RecordingButtonOpenMode from;
  final Group? group;

  RecordingScreen({required this.from, required this.group});

  @override
  Widget build(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () => unFocusKeyboard(
          context: context,
          onUnFocused: (){
            final recordingViewModel = context.read<RecordingViewModel>();
            recordingViewModel.updateForNotTyping();
          }),
      child: Scaffold(
        appBar: AppBar(
          leading: _backButton(context),
          title: Consumer<RecordingViewModel>(
            builder: (context, model, child) {
              return model.isTyping ? Container() : Text("New Talk");
            },
          ),
          actions: [
            Consumer<RecordingViewModel>(builder: (context, model, child) {
              return model.isTyping
                  ? TextButton(
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
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PostDescriptionPart(
                  ),
                  RecordingButtonPart(from: from, group: group),
                ],
              ),
            )
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
}
