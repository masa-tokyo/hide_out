import 'package:flutter/material.dart';


class ButtonWithImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final Text label;
  final Color? color;
  final double? height;
  final double? width;
  final bool isBordered;

  ButtonWithImage(
      {required this.onPressed,
      required this.imagePath,
      required this.label,
        required this.isBordered,
      this.color,
      this.height,
      this.width});

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
              Image.asset(
                imagePath,
                height: height ?? null,
                width: width ?? null,
              ),
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
