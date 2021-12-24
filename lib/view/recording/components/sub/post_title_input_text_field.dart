import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/view_models/recording_view_model.dart';

class PostTitleInputTextField extends StatefulWidget {
  @override
  _PostTitleInputTextFieldState createState() => _PostTitleInputTextFieldState();
}

class _PostTitleInputTextFieldState extends State<PostTitleInputTextField> {
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    _titleController.addListener(_onTitleUpdated);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        autofocus: true,
        controller: _titleController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "(No Title)",
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

  _onTitleUpdated() {
  final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
  recordingViewModel.title = _titleController.text;

  }

}
