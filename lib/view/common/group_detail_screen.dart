import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/common/items/dialog/help_dialog.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';

import '../../utils/style.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  final GroupDetailScreenOpenMode from;

  GroupDetailScreen({@required this.group, @required this.from});

  @override
  Widget build(BuildContext context) {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    Future(() => joinGroupViewModel.getMemberInfo(group));

    return Scaffold(
      appBar: AppBar(
        title: Text(group.groupName),
      ),
      body: Consumer<JoinGroupViewModel>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 36.0,
              ),
              _memberPart(context, model),
              SizedBox(
                height: 12.0,
              ),
              _periodPart(context),
              SizedBox(
                height: 16.0,
              ),
              _aboutPart(),
              SizedBox(
                height: 24.0,
              ),
              from == GroupDetailScreenOpenMode.LOGIN || from == GroupDetailScreenOpenMode.JOIN
                  ? model.groupMembers.length < 5
                      ? _joinButton(context)
                      : _unAvailableButton(context)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _memberPart(BuildContext context, JoinGroupViewModel model) {
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: model.isProcessing
                ? Center(child: CircularProgressIndicator())
                : model.groupMembers.isEmpty
                    ? Text(
                        "-No Member-",
                        style: groupDetailMemberNameTextStyle,
                      )
                    : ListView.builder(
                        itemCount: model.groupMembers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          final member = model.groupMembers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              member.inAppUserName,
                              style: groupDetailMemberNameTextStyle,
                            ), //todo connect to user profile
                          );
                        }),
          ),
        ],
      ),
    );
  }

  Widget _periodPart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Auto-Exit Period",
                style: groupDetailLabelTextStyle,
              ),
              _helpIcon(context),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: textFieldFillColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                group.autoExitDays != null ? "${group.autoExitDays} Days" : "No requirement",
                style: groupDetailDescriptionTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _helpIcon(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.help_outline),
        tooltip: "Members will be kicked out of the group after certain period of time.",
        onPressed: () => showHelpDialog(
              context: context,
              contentString:
                  "Members will be kicked out of the group after certain period of time.",
              okayString: "Okay",
            ));
  }

  Widget _aboutPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            "About",
            style: groupDetailLabelTextStyle,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: textFieldFillColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  group.description,
                  style: groupDetailDescriptionTextStyle,
                ),
              )),
        ),
      ],
    );
  }

  Widget _joinButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(buttonEnabledColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          onPressed: () => _joinButtonPressed(context, group),
          child: Text(
            "Join",
            style: enabledButtonTextStyle,
          ),
        ),
      ),
    );
  }

  _joinButtonPressed(BuildContext context, Group group) async {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    await joinGroupViewModel.chooseGroup(group);
    await joinGroupViewModel.joinGroup();

    switch (from) {
      case GroupDetailScreenOpenMode.LOGIN:
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context, _createRoute(context, HomeScreen()));
        break;
      case GroupDetailScreenOpenMode.JOIN:
        Navigator.pop(context);
        Navigator.pop(context);
        break;
      case GroupDetailScreenOpenMode.GROUP:
        break;
    }

    Fluttertoast.showToast(msg: "Done!", gravity: ToastGravity.CENTER);
  }

  Route<Object> _createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }

  Widget _unAvailableButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonNotEnabledColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: () => showHelpDialog(
                context: context,
                contentString: "[Unavailable] Wait for a vacancy!",
                okayString: "Okay"),
            child: Text(
              "This group is full.",
              style: unavailableButtonTextStyle,
            )),
      ),
    );
  }
}
