import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class AfterRecordingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _againButton(context),
        // SizedBox(width: 0.0,),
        _sendButton(),
      ],
    );
  }

  Widget _againButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: RaisedButton(
            elevation: 3.0,
            onPressed: () => _onAgainButtonPressed(context),
            child: FaIcon(FontAwesomeIcons.undo, size: 30.0,),
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 8.0,),
        Text("Again", style: underButtonLabelTextStyle,),
      ],
    );
  }

  _onAgainButtonPressed(BuildContext context) async{
    //change RecordingButtonStatus from AFTER to BEFORE
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel.changeStatus();


    //todo delete the recording

    //todo pop up dialog to make sure?
  }

  Widget _sendButton() {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: RaisedButton(
            elevation: 3.0,
            onPressed: () => _onSendButtonPressed(),
            child: Icon(Icons.send, size: 30.0,),
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 8.0,),
        Text("Send", style: underButtonLabelTextStyle,),
      ],
    );

  }

  _onSendButtonPressed() {
    //todo post the recording

  }


}
