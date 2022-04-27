import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/custom_alert_dialog.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';
import 'package:hide_out/view/group/group_screen.dart';
import 'package:hide_out/view_models/home_screen_view_model.dart';
import 'package:provider/provider.dart';

class MyGroupPart extends StatelessWidget {
  MyGroupPart({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey globalKey;

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
            key: globalKey,
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
                _showAlertAutoExitDialog(context, model.notifications);
                _showAutoExitDialog(context, model.notifications);
                _showDeletedGroupDialog(context, model.notifications);
                _showNewOwnerDialog(context, model.notifications);
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
              "Join or start a group below!",
              style: newGroupIntroTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertAutoExitDialog(
      BuildContext context, List<d.Notification> notifications) async {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    var alertNotifications = notifications.where((element) =>
        element.notificationType == NotificationType.ALERT_AUTO_EXIT);

    if (alertNotifications.isNotEmpty) {
      alertNotifications.forEach((element) {
        Future(() => showCustomAlertDialog(
            context: context,
            titleStr: "Warning!",
            contentStr:
                'You are about to be kicked out of "${element.content}". Please make a recording TODAY!',
            confirmedStr: "I will do it!",
            circleColor: Colors.red.shade400,
            icon: Icon(
              FontAwesomeIcons.calendarAlt,
              size: 28.0,
              color: Colors.white,
            ),
            onConfirmed: () {
              homeScreenViewModel.deleteNotification(element.notificationId);
              homeScreenViewModel.updateIsAlerted(
                  element.groupId!, element.userId!);
            }));
      });
    }
  }

  void _showAutoExitDialog(
      BuildContext context, List<d.Notification> notifications) async {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    var autoExitNotifications = notifications.where(
        (element) => element.notificationType == NotificationType.AUTO_EXIT);

    if (autoExitNotifications.isNotEmpty) {
      autoExitNotifications.forEach((element) {
        Future(() => showCustomAlertDialog(
            context: context,
            titleStr: "Sorry to see you go!",
            contentStr: "You were kicked out of '${element.content}'. "
                "But don't cry! You can join the group again!!",
            confirmedStr: "Okay!",
            circleColor: Colors.blue.shade400,
            icon: Icon(
              FontAwesomeIcons.sadTear,
              color: Colors.white,
              size: 28.0,
            ),
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

  void _showNewOwnerDialog(
      BuildContext context, List<d.Notification> notifications) {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    var newOwnerNotifications = notifications.where(
        (element) => element.notificationType == NotificationType.NEW_OWNER);

    if (newOwnerNotifications.isNotEmpty) {
      newOwnerNotifications.forEach((element) {
        Future(() => showHelpDialog(
            context: context,
            title: Text("You are the owner!"),
            contentString:
                'In "${element.content}", you have become the new owner because the previous owner exited from the group.',
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
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, int index) {
          final group = groups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(alignment: Alignment.topRight, children: [
              Card(
                color: darkBackgroundButtonColor,
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
                        group.groupName,
                        style: darkBackgroundListTileTextStyle,
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
                            "${notifications.where((element) => element.notificationType == NotificationType.NEW_POST && element.groupId == group.groupId).length}"),
                      ),
                    )
                  : const SizedBox.shrink(),
            ]),
          );
        });
  }
}
