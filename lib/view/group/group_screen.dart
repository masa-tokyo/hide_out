import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/items/dialog/confirm_dialog.dart';
import 'package:voice_put/view/group/group_detail_edit_screen.dart';
import 'package:voice_put/view/common/group_detail_screen.dart';
import 'package:voice_put/view/recording/preparation_note_screen.dart';
import 'package:voice_put/view_models/group_view_model.dart';

import 'components/audio_play_button.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  GroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    Future(() => groupViewModel.getGroupPosts(group));

   Future(() => groupViewModel.getGroupInfo(group.groupId)); //for updating autoExitDays after editing

    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      appBar: AppBar(
        title: FutureBuilder(
            future: groupViewModel.returnGroupInfo(group.groupId),
            builder: (context, AsyncSnapshot<Group> snapshot) {
              return snapshot.hasData
                  ? Text(snapshot.data.groupName)
                  : Text(""); //for updating after editing
            }),
        actions: [_groupEditButton(context)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await groupViewModel.getGroupPosts(group);
          //in order to update the group name after the owner edit it
          await groupViewModel.getGroupInfo(group.groupId);
        },
        child: _postListView(context),
      ),
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

  //---------------------------------------------------------------------------------------------- FloatingActionButton
  _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.keyboard_voice), onPressed: () => _openPreparationNoteScreen(context));
  }

  _openPreparationNoteScreen(BuildContext context) {
    Navigator.push(
        context,
        _createRoute(
            context,
            PreparationNoteScreen(
              from: RecordingButtonOpenMode.POST_FROM_GROUP,
              group: group,
            )));
  }

  //---------------------------------------------------------------------------------------------- AppBar

  Widget _groupEditButton(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    return Consumer<GroupViewModel>(
      builder: (context, model, child) {
        return PopupMenuButton(
            color: popupMenuButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            icon: Icon(Icons.more_vert),
            onSelected: (value) => _onPopupMenuSelected(context, value, model),
            itemBuilder: (context) {
              if (groupViewModel.currentUser.userId == group.ownerId) {
                return [
                  PopupMenuItem(
                      value: GroupEditMenu.EDIT,
                      child: Text(
                        "Group Info",
                        style: groupEditMenuTextStyle,
                      )),
                  PopupMenuItem(
                      value: GroupEditMenu.LEAVE,
                      child: Text(
                        "Leave Group",
                        style: groupEditMenuTextStyle,
                      )),
                  PopupMenuItem(
                      value: GroupEditMenu.CLOSE,
                      child: Text(
                        "Close Group",
                        style: GroupEditMenuCautionTextStyle,
                      )),
                ];
              } else {
                return [
                  PopupMenuItem(
                      value: GroupEditMenu.NO_EDIT,
                      child: Text(
                        "Group Info",
                        style: groupEditMenuTextStyle,
                      )),
                  PopupMenuItem(
                      value: GroupEditMenu.LEAVE,
                      child: Text(
                        "Leave Group",
                        style: GroupEditMenuCautionTextStyle,
                      )),
                ];
              }
            });
      },
    );
  }

  _onPopupMenuSelected(BuildContext context, GroupEditMenu selectedMenu, GroupViewModel model) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    switch (selectedMenu) {
      case GroupEditMenu.EDIT:
        Navigator.push(
            context,
            _createRoute(
                context,
                GroupDetailEditScreen(
                  group: model.group,
                )));
        break;

      case GroupEditMenu.NO_EDIT:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    GroupDetailScreen(group: group, from: GroupDetailScreenOpenMode.GROUP)));
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

                Fluttertoast.showToast(msg: "You have left the group.");

              }
            },
            yesText: Text(
              "Leave",
              style: showConfirmDialogYesTextStyle,
            ),
            noText: Text(
              "Cancel",
              style: showConfirmDialogNoTextStyle,
            ));
        break;
      case GroupEditMenu.CLOSE:
        showConfirmDialog(
          context: context,
          titleString: "CAUTION",
          contentString: "If you close the group, all the audio data will be deleted.",
          onConfirmed: (isConfirmed) async{
            if (isConfirmed) {

              await groupViewModel.closeGroup(group);
              Navigator.pop(context);

              Fluttertoast.showToast(msg: "You have closed the group.");

            }
          },
          yesText: Text(
            "CLOSE",
            style: showConfirmDialogYesTextStyle,
          ),
          noText: Text(
            "Cancel",
            style: showConfirmDialogNoTextStyle,
          ),
        );
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
                    itemBuilder: (context, int index) {
                      final post = model.posts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          post.userId == model.currentUser.userId
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Card(
                                      color: currentUserListTileColor,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0)),
                                      child: Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.25,
                                        child: ListTile(
                                          trailing: AudioPlayButton(
                                            audioUrl: post.audioUrl,
                                            audioPlayType: AudioPlayType.POST_MINE,
                                          ),
                                          title: RichText(
                                              text: TextSpan(
                                                  style: DefaultTextStyle.of(context).style,
                                                  children: [
                                                TextSpan(
                                                    text: post.title, style: postTitleTextStyle),
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
                                      )),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Card(
                                    color: listTileColor,
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0)),
                                    child: ListTile(
                                      trailing: AudioPlayButton(
                                        audioUrl: post.audioUrl,
                                        audioPlayType: AudioPlayType.POST_OTHERS,
                                        postId: post.postId,
                                      ),
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
                                  ),
                                ),
                          post.userId == model.currentUser.userId
                              ? FutureBuilder(
                                  future: groupViewModel.isListened(post),
                                  builder: (context, AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.hasData && snapshot.data) {
                                      return Text(
                                        "Listened",
                                        style: listenedDescriptionTextStyle,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                              : Container(),
                        ],
                      );
                    },
                  );
          },
        ));
  }

  _onDeleteTapped(BuildContext context, Post post) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    showConfirmDialog(
        context: context,
        titleString: "Delete the post?",
        contentString: "You will permanently lose the data.",
        onConfirmed: (isConfirmed) async {
          if (isConfirmed) {
            await groupViewModel.deletePost(post);
            Fluttertoast.showToast(msg: "Post Deleted", gravity: ToastGravity.CENTER);

            await groupViewModel.getGroupPosts(group);
          }
        },
        yesText: Text(
          "Delete",
          style: showConfirmDialogYesTextStyle,
        ),
        noText: Text(
          "Cancel",
          style: showConfirmDialogNoTextStyle,
        ));
  }
}
