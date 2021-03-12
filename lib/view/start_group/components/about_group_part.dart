import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/start_group/components/sub/about_group_input_text_field.dart';

class AboutGroupPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("About", style: startGroupLabelTextStyle,),
        ),
        AboutGroupInputTextField(),
      ],
    );
  }
}

