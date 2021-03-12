import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class JournalDescriptionPart extends StatelessWidget {
  final String questionString1;
  final String questionString2;
  final String questionString3;
  JournalDescriptionPart({@required this.questionString1, @required this.questionString2, @required this.questionString3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height:54.0),
        Text(questionString1, style: preparationTextStyle,),
        SizedBox(height:8.0),
        Text(questionString2, style: preparationTextStyle,),
        SizedBox(height:8.0),
        Text(questionString3, style: preparationTextStyle,),
      ],
    );
  }
}
