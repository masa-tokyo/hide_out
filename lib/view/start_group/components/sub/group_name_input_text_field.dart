import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

class GroupNameInputTextField extends StatefulWidget {
  @override
  _GroupNameInputTextFieldState createState() => _GroupNameInputTextFieldState();
}

class _GroupNameInputTextFieldState extends State<GroupNameInputTextField> {
  TextEditingController _groupNameController = TextEditingController();


  @override
  void initState() {
    _groupNameController.addListener(_onGroupNameUpdated);
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _groupNameController,
        maxLines: null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          hintText: "Type your group name..."
        ),
        autofocus: true,
      ),
    );
  }

  void _onGroupNameUpdated(){
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    startGroupViewModel.updateGroupName(_groupNameController.text);
    print("groupName: ${startGroupViewModel.groupName}");


  }

}
