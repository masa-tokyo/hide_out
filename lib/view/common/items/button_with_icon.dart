import 'package:flutter/material.dart';


class ButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Text label;
  final Color? color;
  final bool isBordered;

  ButtonWithIcon(
      {required this.onPressed,
        required this.icon,
        required this.label,
        required this.isBordered,
        this.color,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            side: isBordered ? MaterialStateProperty.all<BorderSide>(
                BorderSide(
                    width: 0.6
                )
            ) : null,
            backgroundColor: MaterialStateProperty.all<Color?>(color)),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                width: 16,
              ),
              label,
            ],
          ),
        ),
      ),
    );
  }
}
