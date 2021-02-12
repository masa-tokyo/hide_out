import 'package:flutter/material.dart';

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
    var maxLines = 15;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: _controller,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Note",
        ),
      ),
    );

  }
}
