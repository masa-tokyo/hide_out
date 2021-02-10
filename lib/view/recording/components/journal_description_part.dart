import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class JournalDescriptionPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.0,),
        Text("Preparation", style: preparationTextStyle,),
        Text("Look Back Today with voice"),
      ],
    );
  }
}
