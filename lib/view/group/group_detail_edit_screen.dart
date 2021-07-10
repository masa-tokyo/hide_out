import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/components/auto_exit_period_part.dart';
import 'package:voice_put/view/profile/profile_screen.dart';
import 'package:voice_put/view_models/group_view_model.dart';

class GroupDetailEditScreen extends StatefulWidget {
  final Group? group;

  GroupDetailEditScreen({required this.group});

  @override
  _GroupDetailEditScreenState createState() => _GroupDetailEditScreenState();
}

class _GroupDetailEditScreenState extends State<GroupDetailEditScreen> {
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
    await groupViewModel.getGroupInfo(widget.group!.groupId);

    _groupNameController.text = groupViewModel.group!.groupName!;
    _descriptionController.text = groupViewModel.group!.description!;
  }

  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    Future(() => groupViewModel.getMemberInfo(widget.group!));
    Future(() => groupViewModel.updateAutoExitPeriod(widget.group!.autoExitDays));

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<GroupViewModel>(
          builder: (context, model, child) {
            return RefreshIndicator(
              onRefresh: () async {
                //in order to update after the owner edit the info and open it again
                await groupViewModel.getGroupInfo(widget.group!.groupId);
                _groupNameController.text = groupViewModel.group!.groupName!;
                _descriptionController.text = groupViewModel.group!.description!;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text("Group Name", style: groupDetailLabelTextStyle,),
                  ),
                  _groupNameTextInput(),
                  SizedBox(
                    height: 16.0,
                  ),
                  _memberInfo(model),
                  SizedBox(
                    height: 16.0,
                  ),
                  AutoExitPeriodPart(isBeginningGroup: false, group: model.group,),
                  SizedBox(height: 16.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text("About", style: groupDetailLabelTextStyle,),
                  ),
                  _descriptionTextInput(),
                  SizedBox(
                    height: 16.0,
                  ),
                  _updateButton(model),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            );
          },),
      ),
    );
  }


  Widget _groupNameTextInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

  Widget _memberInfo(GroupViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Member",
                style: groupDetailLabelTextStyle,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "(${model.groupMembers.length} / 5)",
                style: groupDetailLabelTextStyle,
              ),
            ],
          ),
          SizedBox(height: 8.0,),
          model.isProcessing
              ? Center(child: CircularProgressIndicator())
              : model.groupMembers.isEmpty
              ? Text(
            "-No Member-",
            style: groupDetailMemberNameTextStyle,
          )
              : Container(
            decoration: BoxDecoration(
              color: textFieldFillColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
                itemCount: model.groupMembers.length,
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  final member = model.groupMembers[index];
                  return ListTile(
                    onTap: () => _openProfileScreen(context, member, model),
                    title: Text(
                      member.inAppUserName!,
                      style: groupDetailMemberNameTextStyle,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20.0,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _openProfileScreen(BuildContext context, User member, GroupViewModel model) {

    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(
      isCurrentUser: model.currentUser == member ? true : false,
      user: member,
    )));
  }


  Widget _descriptionTextInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

  Widget _updateButton(GroupViewModel model) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: (_groupNameController.text != groupViewModel.group!.groupName ||
                      _descriptionController.text != groupViewModel.group!.description ||
                      model.autoExitDays != widget.group!.autoExitDays
                  ) ? MaterialStateProperty.all<Color>(buttonEnabledColor)
                      : MaterialStateProperty.all<Color?>(buttonNotEnabledColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )
              ),
              onPressed: () => _updateInfo(model),
              child: Text(
                  "Update",
                  style: enabledButtonTextStyle
              ),
            ),
          ),
        );
  }

  _updateInfo(GroupViewModel model) async {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    if (_groupNameController.text != groupViewModel.group!.groupName ||
        _descriptionController.text != groupViewModel.group!.description ||
        model.autoExitDays != widget.group!.autoExitDays) {
      await groupViewModel.updateGroupInfo(widget.group!.groupId);
      Navigator.pop(context);

      Fluttertoast.showToast(msg: "Updated", gravity: ToastGravity.CENTER);
    }
  }


}