import 'package:flutter/material.dart';
import 'package:voice_put/view/recording/components/sub/post_note_text_field.dart';
import 'package:voice_put/view/recording/components/sub/post_title_input_text_field.dart';

class PostDescriptionPart extends StatelessWidget {
  final String noteText;

  PostDescriptionPart({@required this.noteText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostTitleInputTextField(),
        SizedBox(height: 12.0,),
        PostNoteTextField(noteText: noteText),
      ],
    );
  }
}
