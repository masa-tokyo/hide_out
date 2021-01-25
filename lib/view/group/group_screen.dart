import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/group/group_info_detail_screen.dart';
import 'package:voice_put/view/recording/recording_screen.dart';
import 'package:voice_put/view_models/group_view_model.dart';

import 'components/audio_play_button.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  GroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    Future(() => groupViewModel.getGroupPosts(group));
    //for update of groupName
    Future(() => groupViewModel.getGroupInfo(group.groupId));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_voice),
        onPressed: () => _openRecordingScreen(context),
      ),
      appBar: AppBar(
        title: Consumer<GroupViewModel>(
          builder: (context, model, child){
            return model.isProcessing
                ? Text("")
                : Text(model.group.groupName);
          },
        ),
        actions: [_groupEditButton(context)],
        //todo when coming from StartGroupScreen, change back_arrow to close button
      ),
      body: RefreshIndicator(
            onRefresh: () async {
              await groupViewModel.getGroupPosts(group);
              //in order to update the group name after the owner edit it
              await groupViewModel.getGroupInfo(group.groupId);
            },
            child: _postListView(context)),
    );
  }

  //---------------------------------------------------------------------------------------------- FloatingActionButton

  _openRecordingScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(context, RecordingScreen(group: group)));
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
            child: child,);
        });
  }

  //---------------------------------------------------------------------------------------------- AppBar

  Widget _groupEditButton(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _onPopupMenuSelected(context, value),
        itemBuilder: (context) {
          if (groupViewModel.currentUser.userId == group.ownerId) {
            return [
              PopupMenuItem(
                  value: GroupEditMenu.EDIT,
                  child: Text("Edit Group Info", style: groupEditMenuTextStyle,)),
              PopupMenuItem(
                  value: GroupEditMenu.LEAVE,
                  child: Text("Leave Group", style: leaveGroupMenuTextStyle,)),
            ];
          } else {
            return [
              PopupMenuItem(
                  value: GroupEditMenu.LEAVE,
                  child: Text("Leave Group", style: leaveGroupMenuTextStyle,)),
            ];
          }
        });
  }

  _onPopupMenuSelected(BuildContext context, GroupEditMenu selectedMenu) async{
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    switch (selectedMenu) {
      case GroupEditMenu.EDIT:
        Navigator.push(
            context, _createRoute(context, GroupInfoDetailScreen(isEditable: true, group: group,)));
        break;
      case GroupEditMenu.LEAVE:
        //todo show popup dialog
        await groupViewModel.leaveGroup(group);
        Navigator.pop(context);
        break;
    }
  }


//------------------------------------------------------------------------------------------------ body

  Widget _postListView(BuildContext context) {
    return Consumer<GroupViewModel>(
      builder: (context, model, child) {
        return model.isProcessing
            ? Center(child: CircularProgressIndicator(),)
            : ListView.builder(
            itemCount: model.posts.length,
            itemBuilder: (context, int index) {
              final post = model.posts[index];
              return Card(
                elevation: 2.0,
                child: ListTile(
                  trailing: AudioPlayButton(audioUrl: post.audioUrl),
                  subtitle: Text(post.userName),
                  title: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle
                              .of(context)
                              .style,
                          children: [
                            TextSpan(text: post.title, style: postTitleTextStyle),
                            TextSpan(text: "  "),
                            TextSpan(text: "(${post.audioDuration})",
                                style: postAudioDurationTextStyle),
                          ]
                      )),
                ),
              );
            });
      },
    );
  }


}
