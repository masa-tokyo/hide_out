import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class BeforeRecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardCircle(context),
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

  Widget _forwardCircle(BuildContext context) {
  return Container(
    width: 80.0,
    height: 80.0,
    child: RaisedButton(
        onPressed: () => _onCircleButtonPressed(context),
      elevation: 3.0,
      color: Colors.redAccent,
      shape: CircleBorder(
        ),
    ),
  );
  }

  _onCircleButtonPressed(BuildContext context) async{
    //todo start recording


    //change RecordingButtonStatus from BEFORE to DURING
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel.changeStatus();


  }
}
