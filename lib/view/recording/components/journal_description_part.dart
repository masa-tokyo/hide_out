import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class JournalDescriptionPart extends StatelessWidget {
  final String questionString;
  JournalDescriptionPart({@required this.questionString});

  @override
  Widget build(BuildContext context) {
    return Text(questionString, style: preparationTextStyle,);
  }
}
