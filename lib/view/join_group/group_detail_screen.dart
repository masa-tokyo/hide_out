import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';

import '../../utils/style.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          SizedBox(
            height: 36.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              group.groupName,
              style: groupDetailNameTextStyle,
            ),
          ),
          SizedBox(
            height: 36.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "About",
                  style: groupDetailAboutTextStyle,
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
                      color: boxDecorationColor,
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
          ),
          SizedBox(
            height: 24.0,
          ),
          _joinButton(context)
        ],
      ),
    );
  }

  Widget _joinButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: () => _openGroupScreen(context, group),
          child: Text("Join"),
        ),
      ),
    );
  }

  _openGroupScreen(BuildContext context, Group group) async {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    await joinGroupViewModel.joinGroup(group);

    Navigator.pop(context);
    Navigator.pop(context);

    Fluttertoast.showToast(
        msg: "Done!",
        gravity: ToastGravity.CENTER);

  }

}
