import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class PostNoteTextField extends StatefulWidget {
  final String noteText;
  PostNoteTextField({@required this.noteText});

  @override
  _PostNoteTextFieldState createState() => _PostNoteTextFieldState();
}

class _PostNoteTextFieldState extends State<PostNoteTextField> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = widget.noteText;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var maxLines = 12;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: _controller,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Note",
          filled: true,
        ),
        onTap: () => _updateForKeyboard(context),
      ),
    );

  }

  _updateForKeyboard(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    recordingViewModel.updateForTyping();
  }
}
