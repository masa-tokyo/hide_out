import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/dialog/confirm_dialog.dart';
import 'package:voice_put/view/group/group_info_detail_screen.dart';
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
      appBar: AppBar(
        title: Consumer<GroupViewModel>(
          builder: (context, model, child) {
            return model.isProcessing ? Text("") : Text(model.group.groupName);
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

  //---------------------------------------------------------------------------------------------- AppBar

  Widget _groupEditButton(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    return PopupMenuButton(
        color: popupMenuButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _onPopupMenuSelected(context, value),
        itemBuilder: (context) {
          if (groupViewModel.currentUser.userId == group.ownerId) {
            return [
              PopupMenuItem(
                  value: GroupEditMenu.EDIT,
                  child: Text(
                    "Edit Group Info",
                    style: groupEditMenuTextStyle,
                  )),
              PopupMenuItem(
                  value: GroupEditMenu.LEAVE,
                  child: Text(
                    "Leave Group",
                    style: leaveGroupMenuTextStyle,
                  )),
            ];
          } else {
            return [
              PopupMenuItem(
                  value: GroupEditMenu.LEAVE,
                  child: Text(
                    "Leave Group",
                    style: leaveGroupMenuTextStyle,
                  )),
            ];
          }
        });
  }

  _onPopupMenuSelected(BuildContext context, GroupEditMenu selectedMenu) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    switch (selectedMenu) {
      case GroupEditMenu.EDIT:
        Navigator.push(
            context,
            _createRoute(
                context,
                GroupInfoDetailScreen(
                  isEditable: true,
                  group: group,
                )));
        break;
      case GroupEditMenu.LEAVE:
        showConfirmDialog(
            context: context,
            titleString: "Leave the group?",
            contentString: "",
            onConfirmed: (isConfirmed) async {
              if (isConfirmed) {
                await groupViewModel.leaveGroup(group);
                Navigator.pop(context);
              }
            },
            yesText: Text(
              "Leave",
              style: showConfirmDialogYesTextStyle,
            ),
            noText: Text("Cancel", style: showConfirmDialogNoTextStyle,));
        break;
    }
  }

//------------------------------------------------------------------------------------------------ body

  Widget _postListView(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<GroupViewModel>(
        builder: (context, model, child) {
          return model.isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: model.posts.length,
                  itemBuilder: (context, int index){
                    final post = model.posts[index];
                    return Card(
                      color: post.userId == model.currentUser.userId
                      ? currentUserListTileColor : listTileColor,
                      elevation: 2.0,
                      child: post.userId == model.currentUser.userId
                          ? Column(
                            children: [
                              Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: ListTile(
                                    trailing: AudioPlayButton(audioUrl: post.audioUrl, isPostUser: true,),
                                    subtitle: Text(post.userName),
                                    title: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: [
                                          TextSpan(text: post.title, style: postTitleTextStyle),
                                          TextSpan(text: "  "),
                                          TextSpan(
                                              text: "(${post.audioDuration})",
                                              style: postAudioDurationTextStyle),
                                        ])),
                                  ),
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: "Delete",
                                      icon: Icons.delete,
                                      color: Colors.redAccent,
                                      onTap: () => _onDeleteTapped(context, post),
                                    )
                                  ],
                                ),
                              FutureBuilder(
                                  future: groupViewModel.isListened(post),
                                  builder: (context, AsyncSnapshot<bool> snapshot){
                                    if(snapshot.hasData && snapshot.data){
                                      return Text("Listened");
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ],
                          )
                          : ListTile(
                              trailing: AudioPlayButton(audioUrl: post.audioUrl, isPostUser: false, postId: post.postId,),
                              subtitle: Text(post.userName),
                              title: RichText(
                                  text:
                                      TextSpan(style: DefaultTextStyle.of(context).style, children: [
                                TextSpan(text: post.title, style: postTitleTextStyle),
                                TextSpan(text: "  "),
                                TextSpan(
                                    text: "(${post.audioDuration})",
                                    style: postAudioDurationTextStyle),
                              ])),
                            ),
                    );
                  });
        },
      ),
    );
  }

  _onDeleteTapped(BuildContext context, Post post) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    showConfirmDialog(
        context: context,
        titleString: "Delete the post?",
        contentString: "You will permanently lose the data.",
        onConfirmed: (isConfirmed) async{
          if(isConfirmed){
            await groupViewModel.deletePost(post);
            Fluttertoast.showToast(
              msg: "Post Deleted",
              gravity: ToastGravity.CENTER
            );

            await groupViewModel.getGroupPosts(group);
          }
        },
        yesText: Text("Delete", style: showConfirmDialogYesTextStyle,),
        noText: Text("Cancel", style: showConfirmDialogNoTextStyle,));

  }
}
