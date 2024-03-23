import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/group_detail_screen.dart';
import 'package:hide_out/view/common/items/dialog/confirm_dialog.dart';
import 'package:hide_out/view/common/items/user_avatar.dart';
import 'package:hide_out/view/group/group_detail_edit_screen.dart';
import 'package:hide_out/view/recording/recording_screen.dart';
import 'package:hide_out/view_models/group_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'components/post_audio_play_button.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  GroupScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    Future(() => groupViewModel.resetPlayer());
    Future(() => groupViewModel.getGroupPosts(group));

    Future(() => groupViewModel
        .getGroupInfo(group.groupId)); //for updating autoExitDays after editing
    Future(() => groupViewModel.getNotifications());

    return Theme(
      data: lightTheme,
      child: PopScope(
        onPopInvoked: (didPop) async {
          // stop audio when the user closes the screen
          // * with this, iOS users cannot close the screen by swiping
          if (didPop) {
            groupViewModel.pauseAudio();
          }
        },
        child: Scaffold(
          floatingActionButton: _floatingActionButton(context),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () {
                groupViewModel.pauseAudio();
                Navigator.pop(context);
              },
            ),
            title: FutureBuilder(
                future: groupViewModel.returnGroupInfo(group.groupId),
                builder: (context, AsyncSnapshot<Group> snapshot) {
                  return snapshot.hasData
                      ? Text(snapshot.data!.groupName)
                      : Text(""); //for updating after editing
                }),
            actions: [_groupEditButton(context)],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              groupViewModel.resetPlayer();
              await groupViewModel.getGroupPosts(group);
              //in order to update the group name after the owner edit it
              await groupViewModel.getGroupInfo(group.groupId);
              await groupViewModel.getNotifications();
            },
            child: Column(
              children: [
                _postListView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------- FloatingActionButton
  _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.solidCommentDots),
        onPressed: () => _openRecordingScreen(context));
  }

  _openRecordingScreen(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    groupViewModel.pauseAudio();

    Navigator.push(
      context,
      createRoute(
        context,
        RecordingScreen(
            from: RecordingButtonOpenMode.POST_FROM_GROUP, group: group),
      ),
    );
  }

  //------------------------------------------------------------------------------ AppBar

  Widget _groupEditButton(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    return Consumer<GroupViewModel>(
      builder: (context, model, child) {
        return PopupMenuButton(
            color: lightThemeBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            icon: Icon(Icons.more_vert),
            onSelected: (dynamic value) =>
                _onPopupMenuSelected(context, value, model),
            itemBuilder: (context) {
              if (groupViewModel.currentUser!.userId == group.ownerId) {
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
                      value: GroupEditMenu.DELETE,
                      child: Text(
                        "Delete Group",
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

  _onPopupMenuSelected(
      BuildContext context, GroupEditMenu selectedMenu, GroupViewModel model) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    switch (selectedMenu) {
      case GroupEditMenu.EDIT:
        Navigator.push(
            context,
            createRoute(
                context,
                GroupDetailEditScreen(
                  group: model.group!,
                )));
        break;

      case GroupEditMenu.NO_EDIT:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => GroupDetailScreen(
                    group: group, from: GroupDetailScreenOpenMode.GROUP)));
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
            ));
        break;
      case GroupEditMenu.DELETE:
        showConfirmDialog(
          context: context,
          titleString: "CAUTION",
          contentString:
              "If you delete the group, all the audio data will be also deleted.",
          onConfirmed: (isConfirmed) async {
            if (isConfirmed) {
              await groupViewModel.deleteGroup(group);
              Navigator.pop(context);

              Fluttertoast.showToast(msg: "You have deleted the group.");
            }
          },
          yesText: Text(
            "DELETE",
            style: showConfirmDialogYesTextStyle,
          ),
          noText: Text(
            "Cancel",
          ),
        );
    }
  }

//------------------------------------------------------------------------------body

  Widget _postListView(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 60.0),
          //for space of FloatingActionButton
          child: Consumer<GroupViewModel>(
            builder: (context, model, child) {
              return model.isProcessing
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.posts.length,
                      itemBuilder: (context, int index) {
                        final post = model.posts[index];
                        return Column(
                          children: [
                            _postDateFormat(model, post, index),
                            post.userId == model.currentUser!.userId
                                ? _currentUserPost(context, index, post)
                                : _memberPost(context, index, model, post),
                          ],
                        );
                      },
                    );
            },
          )),
    );
  }

  Widget _postDateFormat(GroupViewModel model, Post post, int index) {
    final postDateTime = post.postDateTime!;
    final now = DateTime.now();

    var dateStr = "";

    if (postDateTime.year == now.year &&
        postDateTime.month == now.month &&
        postDateTime.day == now.day) {
      dateStr = "Today";
    } else if (postDateTime.year == now.year &&
        postDateTime.month == now.month &&
        postDateTime.day == now.day - 1) {
      dateStr = "Yesterday";
    } else {
      dateStr = DateFormat.MMM().format(postDateTime) +
          " " +
          DateFormat.d().format(postDateTime);
    }

    //check whether a newer post is posted on the same date or not
    if (index != 0) {
      final newerPost = model.posts[index - 1];
      final newerPostDateTime = newerPost.postDateTime!;

      if (postDateTime.year == newerPostDateTime.year &&
          postDateTime.month == newerPostDateTime.month &&
          postDateTime.day == newerPostDateTime.day) {
        return const SizedBox.shrink();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
      child: Text(
        dateStr,
        style: dateFormatTextStyle,
      ),
    );
  }

  Widget _currentUserPost(BuildContext context, int index, Post post) {
    // ignore: deprecated_member_use
    final scale = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Card(
              color: currentUserListTileColor,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              )),
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: ListTile(
                  onLongPress: () => _deleteCurrentUserPost(context, post),
                  trailing: SizedBox(
                    width: 50,
                    height: 50,
                    child: PostAudioPlayButton(
                      color: lightThemeBackgroundColor!,
                      index: index,
                      audioPlayType: AudioPlayType.POST_MINE,
                    ),
                  ),
                  title: RichText(
                      text: TextSpan(
                          // RichText does not consider the font size set on user preferences
                          style: scaledFontTextStyle(
                              DefaultTextStyle.of(context).style,
                              textScale: scale),
                          children: [
                        TextSpan(
                            text: post.title,
                            style: scaledFontTextStyle(postTitleTextStyle,
                                textScale: scale)),
                        TextSpan(text: "  "),
                        TextSpan(
                            text: "(${post.audioDuration})",
                            style: scaledFontTextStyle(
                                postAudioDurationTextStyle,
                                textScale: scale)),
                      ])),
                ),
                secondaryActions: [
                  IconSlideAction(
                    caption: "Delete",
                    icon: Icons.delete,
                    color: Colors.redAccent,
                    onTap: () => _deleteCurrentUserPost(context, post),
                  )
                ],
              )),
        ),
        post.isListened!
            ? Text(
                "Listened",
                style: listenedDescriptionTextStyle,
              )
            : const SizedBox.shrink(),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }

  _deleteCurrentUserPost(BuildContext context, Post post) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    showConfirmDialog(
        context: context,
        titleString: "Delete the post?",
        contentString: "You will permanently lose the data.",
        onConfirmed: (isConfirmed) async {
          if (isConfirmed) {
            await groupViewModel.deletePost(post);
            Fluttertoast.showToast(
                msg: "Post Deleted", gravity: ToastGravity.CENTER);
          }
        },
        yesText: Text(
          "Delete",
          style: showConfirmDialogYesTextStyle,
        ),
        noText: Text(
          "Cancel",
        ));
  }

  Widget _memberPost(
      BuildContext context, int index, GroupViewModel model, Post post) {
    // ignore: deprecated_member_use
    final scale = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: 1,
              child: UserAvatar(
                radius: 20.0,
                url: _getPhotoUrl(group, post),
              )),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.topRight, children: [
                  Column(
                    children: [
                      Card(
                        color: memberListTitleColor,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: ListTile(
                          onLongPress: () => _removeMemberPost(context, post),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: PostAudioPlayButton(
                              color: lightThemeBackgroundColor!,
                              index: index,
                              audioPlayType: AudioPlayType.POST_OTHERS,
                              post: post,
                            ),
                          ),
                          title: RichText(
                              text: TextSpan(
                                  // RichText does not consider the font size set on user preferences
                                  style: scaledFontTextStyle(
                                      DefaultTextStyle.of(context).style,
                                      textScale: scale),
                                  children: [
                                TextSpan(
                                    text: post.title,
                                    style: scaledFontTextStyle(
                                        postTitleTextStyle,
                                        textScale: scale)),
                                TextSpan(text: "  "),
                                TextSpan(
                                    text: "(${post.audioDuration})",
                                    style: scaledFontTextStyle(
                                        postAudioDurationTextStyle,
                                        textScale: scale)),
                              ])),
                        ),
                      ),
                    ],
                  ),
                  model.notifications
                          .any((element) => element.postId == post.postId)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notificationBadgeColor),
                          ),
                        )
                      : Container(),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                    left: 8.0,
                  ),
                  child: Text(
                    post.userName!,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _getPhotoUrl(Group group, Post post) {
    if (group.members.any((member) => member.userId == post.userId)) {
      return group.members
          .firstWhere((member) => member.userId == post.userId)
          .photoUrl;
    } else {
      return userIconUrl;
    }
  }

  _removeMemberPost(BuildContext context, Post post) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    showConfirmDialog(
        context: context,
        titleString: "Remove the post?",
        contentString: "The post will be removed only for you.",
        onConfirmed: (isConfirmed) async {
          if (isConfirmed) {
            await groupViewModel.removeMemberPost(post);
            Fluttertoast.showToast(
                msg: "Post Removed", gravity: ToastGravity.CENTER);
          }
        },
        yesText: Text(
          "Remove",
          style: showConfirmDialogYesTextStyle,
        ),
        noText: Text(
          "Cancel",
        ));
  }
}
