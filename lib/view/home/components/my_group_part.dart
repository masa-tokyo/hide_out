import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/notification.dart' as d;
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/common/items/dialog/help_dialog.dart';
import 'package:voice_put/view/group/group_screen.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';

class MyGroupPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    Future(() => homeScreenViewModel.getMyGroup());
    Future(() => homeScreenViewModel.getNotifications());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            "My Group",
            style: homeScreenLabelTextStyle,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Consumer<HomeScreenViewModel>(
          builder: (context, model, child) {
            if (model.isProcessing) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (model.isFirstCall) {
                homeScreenViewModel.stopCall();
                _showAutoExitDialog(context, model.notifications);
                _showDeletedGroupDialog(context, model.notifications);
              }

              return model.groups.isEmpty
                  ? _newGroupIntro()
                  : _myGroupListView(model.groups, model.notifications);
            }
          },
        ),
      ],
    );
  }

  _openGroupScreen(BuildContext context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupScreen(group: group),
      ),
    );
  }

  Widget _newGroupIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: textFieldFillColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              "*Join/Start Group below",
              style: newGroupIntroTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showAutoExitDialog(
      BuildContext context, List<d.Notification> notifications) async {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    var autoExitNotifications = notifications.where(
        (element) => element.notificationType == NotificationType.AUTO_EXIT);

    if (autoExitNotifications.isNotEmpty) {
      autoExitNotifications.forEach((element) {
        Future(() => showHelpDialog(
            context: context,
            title: Text("Auto-Exit Period"),
            contentString:
                'You have exited from "${element.content}". Please enter again if you want.',
            okayString: "Okay",
            onConfirmed: () {
              homeScreenViewModel.deleteNotification(element.notificationId);
            }));
      });
    }
  }

  void _showDeletedGroupDialog(
      BuildContext context, List<d.Notification> notifications) async {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    var deletedGroupNotifications = notifications.where((element) =>
        element.notificationType == NotificationType.DELETED_GROUP);

    if (deletedGroupNotifications.isNotEmpty) {
      deletedGroupNotifications.forEach((element) {
        Future(() => showHelpDialog(
            context: context,
            title: Text("We are sorry!"),
            contentString:
                'Your group,"${element.content}" was deleted by the group owner.',
            okayString: "Okay",
            onConfirmed: () {
              homeScreenViewModel.deleteNotification(element.notificationId);
            }));
      });
    }
  }

  Widget _myGroupListView(
      List<Group> groups, List<d.Notification> notifications) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: groups.length,
        itemBuilder: (context, int index) {
          final group = groups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(alignment: Alignment.topRight, children: [
              Card(
                color: listTileColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2.0,
                child: InkWell(
                  splashColor: Colors.blueGrey,
                  onTap: () => _openGroupScreen(context, group),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        group.groupName!,
                        style: listTileTitleTextStyle,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    dense: true,
                  ),
                ),
              ),
              notifications.any((element) =>
                      element.notificationType == NotificationType.NEW_POST &&
                      element.groupId == group.groupId)
                  ? Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notificationBadgeColor,
                      ),
                      child: Center(
                        child: Text(
                            "${notifications.where((element)
                            => element.notificationType == NotificationType.NEW_POST
                               && element.groupId == group.groupId).length}"),
                      ),
                    )
                  : Container(),
            ]),
          );
        });
  }
}
