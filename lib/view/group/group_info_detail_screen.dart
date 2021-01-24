import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';


class GroupInfoDetailScreen extends StatefulWidget {
  final bool isEditable;
  final Group group;

  GroupInfoDetailScreen({@required this.isEditable, @required this.group});

  @override
  _GroupInfoDetailScreenState createState() => _GroupInfoDetailScreenState();
}

class _GroupInfoDetailScreenState extends State<GroupInfoDetailScreen> {
  TextEditingController _groupNameController = TextEditingController();


  @override
  void initState() {
    _groupNameController.text = widget.group.groupName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.isEditable
      ? _editableGroupInfo()
      : _viewOnlyGroupInfo(),
    );
  }

  //----------------------------------------------------------------------------------------------Editable
  Widget _editableGroupInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Group Name"),
        ),
        _groupNameTextInput(),
        _descriptionTextInput(),
        _editButton(),
      ],
    );
  }

  Widget _groupNameTextInput() {
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
      ),
    );

  }

  Widget _descriptionTextInput() {
    return Container();

  }


 Widget _editButton() {
    return Container();
 }

  //----------------------------------------------------------------------------------------------View Only
  Widget _viewOnlyGroupInfo() {
    return Container();

  }



}
