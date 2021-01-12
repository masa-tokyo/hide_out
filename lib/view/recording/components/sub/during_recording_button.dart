import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class DuringRecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardRectangle(context),
      ],
    );
  }

  Widget _backwardCircle() {
    return  Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _forwardRectangle(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: RaisedButton(
        onPressed: () => _onRectangleButtonPressed(context),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  _onRectangleButtonPressed(BuildContext context) async{
    //todo stop recording


    //change RecordingButtonStatus from DURING to AFTER
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel.changeStatus();

  }
}
