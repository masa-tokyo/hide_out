import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class RoundedRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  RoundedRaisedButton({@required this.onPressed, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: RaisedButton(
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(label, style: roundedRaisedButtonTextStyle,),
            ),),
      ),
    );
  }
}
