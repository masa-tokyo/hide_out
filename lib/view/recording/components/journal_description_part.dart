import 'package:flutter/material.dart';

class JournalDescriptionPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.0,),
        Text("Preparation",), //todo fontStyle
        Text("Look Back Today with voice"),
      ],
    );
  }
}
