import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class ButtonWithImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String label;
  final Color color;

  ButtonWithImage({@required this.onPressed, @required this.imagePath, @required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          onPressed: onPressed,
          color: color,
          child: Row(
            children: [
              SizedBox(width: 30,),
              Image.asset(imagePath),
              SizedBox(width: 50,),
              Text(label, style: buttonWithImageTextStyle,),
            ],
          ),),
    );
  }
}
