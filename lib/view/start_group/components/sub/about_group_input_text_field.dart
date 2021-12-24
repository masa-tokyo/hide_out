import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/view_models/start_group_view_model.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "Please explain what you want to talk about in this group.",
            filled: true,
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
