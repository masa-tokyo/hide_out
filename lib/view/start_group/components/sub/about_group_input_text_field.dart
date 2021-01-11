import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

class AboutGroupInputTextField extends StatefulWidget {
  @override
  _AboutGroupInputTextFieldState createState() => _AboutGroupInputTextFieldState();
}

class _AboutGroupInputTextFieldState extends State<AboutGroupInputTextField> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.addListener(_onDescriptionUpdated);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintText: "Describe your group..."
        ),
      ),
    );
  }

  void _onDescriptionUpdated(){
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    startGroupViewModel.updateDescription(_descriptionController.text);
    print("description: ${startGroupViewModel.description}");


  }
}
