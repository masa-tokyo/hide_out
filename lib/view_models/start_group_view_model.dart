import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';

class StartGroupViewModel extends ChangeNotifier {
  final UserRepository? userRepository;
  final GroupRepository? groupRepository;

  StartGroupViewModel({this.userRepository, this.groupRepository});

  User? get currentUser => UserRepository.currentUser;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  bool _isFirstTap = true;

  bool get isFirstTap => _isFirstTap;

  String groupName = "";
  String description = "";
  int autoExitDays = 4;

  late Group group;

  Future<void> updateGroupName(String groupNameString) async {
    groupName = groupNameString;
    notifyListeners();
  }

  Future<void> updateDescription(String descriptionString) async {
    description = descriptionString;
    notifyListeners();
  }

  void updateAutoExitPeriod(int? intDays) {
    if (intDays != null) {
      autoExitDays = intDays;
    }
  }

  Future<void> registerGroup() async {
    group = Group(
        groupId: Uuid().v1(),
        groupName: groupName,
        description: description,
        ownerId: currentUser!.userId,
        ownerPhotoUrl: currentUser!.photoUrl,
        autoExitDays: autoExitDays,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        lastActivityAt: DateTime.now().millisecondsSinceEpoch,
        members: [
          GroupMember(
              userId: currentUser!.userId,
              name: currentUser!.inAppUserName,
              photoUrl: currentUser!.photoUrl)
        ]);

    await groupRepository!.registerGroup(group, currentUser!);
  }

  void updateIsFirstTap() {
    _isFirstTap = !_isFirstTap;
    notifyListeners();
  }

  onGroupRegistered(GroupRepository groupRepository) {
    //todo delete this method if not necessary
    _isProcessing = groupRepository.isProcessing;
    notifyListeners();
  }
}
