import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class JournalDescriptionPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.0,),
        Text("Preparation", style: preparationTextStyle,),
        SizedBox(height: 24.0,),
        Text("Look Back Today with Questions:"),
        SizedBox(height: 12.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("-What did you do?"),
            SizedBox(height: 4.0,),
            Text("-What did you feel about them?"),
            SizedBox(height: 4.0,),
            Text("-What did you learn from them?"),
          ],
        ),
      ],
    );
  }
}
