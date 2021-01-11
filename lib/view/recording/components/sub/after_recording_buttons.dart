import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_put/utils/style.dart';

class AfterRecordingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _againButton(),
        // SizedBox(width: 0.0,),
        _sendButton(),
      ],
    );
  }

  Widget _againButton() {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: RaisedButton(
            elevation: 3.0,
            onPressed: () => _onAgainButtonPressed(),
            child: FaIcon(FontAwesomeIcons.undo, size: 30.0,),
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 8.0,),
        Text("Again", style: underButtonLabelTextStyle,),
      ],
    );
  }

  _onAgainButtonPressed() {
    //todo change the state from AFTER to BEFORE

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
