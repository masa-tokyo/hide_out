import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/group_view_model.dart';

class GroupInfoDetailScreen extends StatefulWidget {
  final bool isEditable;
  final Group group;

  GroupInfoDetailScreen({@required this.isEditable, @required this.group});

  @override
  _GroupInfoDetailScreenState createState() => _GroupInfoDetailScreenState();
}

class _GroupInfoDetailScreenState extends State<GroupInfoDetailScreen> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _setTextController();

    _groupNameController.addListener(_onGroupNameUpdated);
    _descriptionController.addListener(_onDescriptionUpdated);

    super.initState();
  }

  Future<void> _setTextController() async {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    //in order to update after the owner edit the info and open it again
    await groupViewModel.getGroupInfo(widget.group.groupId);

    _groupNameController.text = groupViewModel.group.groupName;
    _descriptionController.text = groupViewModel.group.description;
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
      body: SingleChildScrollView(
        child: widget.isEditable ? _editableGroupInfo() : _viewOnlyGroupInfo(),
      ),
    );
  }

  //----------------------------------------------------------------------------------------------Editable
  Widget _editableGroupInfo() {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        //in order to update after the owner edit the info and open it again
        await groupViewModel.getGroupInfo(widget.group.groupId);
        _groupNameController.text = groupViewModel.group.groupName;
        _descriptionController.text = groupViewModel.group.description;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Group Name"),
          ),
          _groupNameTextInput(),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("About"),
          ),
          _descriptionTextInput(),
          SizedBox(
            height: 16.0,
          ),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _groupNameTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _groupNameController,
        maxLines: null,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            filled: true,
            hintText: "Type your group name..."),
      ),
    );
  }

  void _onGroupNameUpdated() {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    groupViewModel.groupName = _groupNameController.text;
    setState(() {});
  }

  Widget _descriptionTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "Describe your group...",
          filled: true,
        ),
      ),
    );
  }

  void _onDescriptionUpdated() {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    groupViewModel.description = _descriptionController.text;
    setState(() {});
  }

  Widget _saveButton() {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: (_groupNameController.text != groupViewModel.group.groupName ||
                _descriptionController.text != groupViewModel.group.description)
                ? MaterialStateProperty.all<Color>(buttonEnabledColor)
                : MaterialStateProperty.all<Color>(buttonNotEnabledColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          ),
          onPressed: () => _updateInfo(),
          child: Text(
            "Save",
            style: enablingButtonTextStyle
          ),
        ),
      ),
    );
  }

  _updateInfo() async {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    if (_groupNameController.text != groupViewModel.group.groupName ||
        _descriptionController.text != groupViewModel.group.description) {
      if (_groupNameController.text != groupViewModel.group.groupName &&
          _descriptionController.text != groupViewModel.group.description) {
        await groupViewModel.updateGroupNameAndDescription();
      } else if (_groupNameController.text != groupViewModel.group.groupName &&
          _descriptionController.text == groupViewModel.group.description) {
        await groupViewModel.updateGroupName();
      } else if (_groupNameController.text == groupViewModel.group.groupName &&
          _descriptionController.text != groupViewModel.group.description) {
        await groupViewModel.updateDescription();
      }

      Navigator.pop(context);
    } else {
      return;
    }
  }

  //----------------------------------------------------------------------------------------------View Only
  Widget _viewOnlyGroupInfo() {
    return Container();
  }
}
