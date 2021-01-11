import 'package:flutter/material.dart';

class BeforeRecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardCircle(),
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

  Widget _forwardCircle() {
  return Container(
    width: 80.0,
    height: 80.0,
    child: RaisedButton(
        onPressed: () => _onCircleButtonPressed(),
      elevation: 3.0,
      color: Colors.redAccent,
      shape: CircleBorder(
        ),
    ),
  );
  }

  _onCircleButtonPressed() {
    //todo start recording

    //todo change the status from BEFORE to DURING
  }
}
