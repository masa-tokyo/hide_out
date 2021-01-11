import 'package:flutter/material.dart';

class DuringRecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardRectangle(),
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

  Widget _forwardRectangle() {
    return Container(
      width: 60.0,
      height: 60.0,
      child: RaisedButton(
        onPressed: () => _onRectangleButtonPressed(),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  _onRectangleButtonPressed() {
    //todo stop recording

    //todo change the state from DURING to AFTER
  }
}
