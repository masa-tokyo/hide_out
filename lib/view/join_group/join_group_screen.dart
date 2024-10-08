import 'package:flutter/material.dart';
import 'package:hide_out/view/home/home_screen.dart';
import 'package:hide_out/view_models/recording_view_model.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/group_detail_screen.dart';
import 'package:hide_out/view/common/items/user_avatar.dart';
import 'package:hide_out/view_models/join_group_view_model.dart';
import 'dart:io';

class JoinGroupScreen extends StatelessWidget {
  final bool isSignedUp;

  JoinGroupScreen({required this.isSignedUp});

  @override
  Widget build(BuildContext context) {
    final joinGroupViewModel =
        Provider.of<JoinGroupViewModel>(context, listen: false);
    Future(() => joinGroupViewModel.getGroupsExceptForMine());

    return Scaffold(
      appBar: AppBar(
        title: Text("Join a Group"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
        ),
        actions: [
          if (isSignedUp)
            TextButton(
              onPressed: () async {
                final recordingViewModel =
                Provider.of<RecordingViewModel>(context, listen: false);
                //change RecordingButtonStatus from AFTER to BEFORE
                await recordingViewModel.updateRecordingButtonStatus(
                    RecordingButtonStatus.BEFORE_RECORDING);
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: ((_) => HomeScreen(isSignedUp: isSignedUp)),
                ),
                (_) => false,
              );
              },
              child: Text(
                'Skip',
                style: skipButtonTextStyle,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<JoinGroupViewModel>(builder: (context, model, child) {
          return model.isProcessing
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: model.groups.length,
                  itemBuilder: (context, int index) {
                    final group = model.groups[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        color: listTileColor,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: InkWell(
                          splashColor: Colors.blueGrey,
                          onTap: () => _openGroupDetailScreen(context, group),
                          child: ListTile(
                            leading: UserAvatar(
                                radius: 26.0,
                                url: group.ownerPhotoUrl ?? userIconUrl),
                            title: Text(group.groupName),
                            subtitle: Text(
                              group.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }

  _openGroupDetailScreen(BuildContext context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((_) => GroupDetailScreen(
              group: group,
              from: isSignedUp
                  ? GroupDetailScreenOpenMode.SIGN_UP
                  : GroupDetailScreenOpenMode.JOIN,
            )),
      ),
    );
  }
}
