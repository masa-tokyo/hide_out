import 'package:flutter/material.dart';
import 'package:hide_out/utils/style.dart';

class RoundedRaisedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  RoundedRaisedButton({required this.label, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color?>(color)
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(label, style: roundedRaisedButtonTextStyle,),
            ),),
      ),
    );
  }
}
