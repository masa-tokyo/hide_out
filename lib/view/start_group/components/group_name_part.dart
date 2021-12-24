import 'package:flutter/material.dart';
import 'package:hide_out/view/start_group/components/sub/group_name_input_text_field.dart';
import 'package:hide_out/utils/style.dart';

class GroupNamePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text("Group Name", style: startGroupLabelTextStyle,),
        ),
        SizedBox(height: 8.0,),
        GroupNameInputTextField(),
      ],
    );
  }
}
