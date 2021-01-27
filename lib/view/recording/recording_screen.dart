import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/dialog/confirm_dialog.dart';
import 'package:voice_put/view/recording/components/post_title_part.dart';
import 'package:voice_put/view/recording/components/recording_button_part.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingScreen extends StatelessWidget {
  final Group group;

  RecordingScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Recording"),
        leading: _closeButton(context),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PostTitlePart(),
          SizedBox(
            height: 1.0,
          ),
          SizedBox(
            height: 1.0,
          ),
          SizedBox(
            height: 1.0,
          ),
          RecordingButtonPart(
            group: group,
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);

    return IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          if (recordingViewModel.recordingButtonStatus == RecordingButtonStatus.DURING_RECORDING
              || recordingViewModel.recordingButtonStatus == RecordingButtonStatus.AFTER_RECORDING){
            showConfirmDialog(
              context: context,
              titleString: "Quit Recording?",
              contentString: "If you tap 'Discard', you will lose the data.",
              onConfirmed: (isConfirmed)async{
                if(isConfirmed) {
                  Navigator.pop(context);
                  await recordingViewModel.updateRecordingButtonStatus(RecordingButtonStatus.BEFORE_RECORDING);
                }
              },
              yesText: Text("Discard", style: showConfirmDialogRedTextStyle,),
              noText: Text("Cancel"),
            );
          } else{
            Navigator.pop(context);
          }
        });
  }
}
