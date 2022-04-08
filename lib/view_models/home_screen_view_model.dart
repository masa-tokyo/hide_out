import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/utils/constants.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final GroupRepository? groupRepository;
  final UserRepository? userRepository;

  HomeScreenViewModel({this.groupRepository, this.userRepository});

  User? get currentUser => UserRepository.currentUser;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  List<Group> _groups = [];

  List<Group> get groups => _groups;

  List<d.Notification> _notifications = [];

  List<d.Notification> get notifications => _notifications;

  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;

  List<int> _calls = [];

  List<int> get calls => _calls;

  bool _isFirstCall = false;

  bool get isFirstCall => _isFirstCall;

  Future<void> getMyGroup() async {
    await groupRepository!.getMyGroup(currentUser!);
  }

  onMyGroupObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.myGroups;
    notifyListeners();
  }

  Future<void> getNotifications() async {
    calls.add(0);
    if (calls.length == 1) {
      _isFirstCall = true;
    }

    await userRepository!.getNotifications();
  }

  onNotificationsFetched(UserRepository userRepository) {
    _notifications = userRepository.notifications;
    _isProcessing = userRepository.isProcessing;
    _isUpdating = userRepository.isUpdating;

    notifyListeners();
  }

  void stopCall() {
    _isFirstCall = false;

    //reset calls after all the getNotifications() were called
    Future.delayed(Duration(seconds: 1)).then((value) {
      _calls.clear();
    });
  }

  Future<void> deleteNotification(String? notificationId) async {
    await userRepository!.deleteNotification(
        notificationId: notificationId,
        notificationDeleteType: NotificationDeleteType.NOTIFICATION_ID);
  }

  Future<void> updateIsAlerted(String groupId, String userId) async {
    await groupRepository!.updateIsAlerted(groupId, userId);
  }
}
