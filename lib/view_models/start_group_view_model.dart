import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class StartGroupViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  StartGroupViewModel({this.userRepository, this.groupRepository});

  User get currentUser => UserRepository.currentUser;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;


  String groupName = "";
  String description = "";
  int autoExitDays = 4;

  Group group;

  Future<void> updateGroupName(String groupNameString) async{
    groupName = groupNameString;
    notifyListeners();
  }

  Future<void> updateDescription(String descriptionString) async{
    description = descriptionString;
    notifyListeners();
  }

  void updateAutoExitPeriod(int intDays) {
    autoExitDays = intDays;
  }


  Future<void> registerGroup() async{
    group = Group(
      groupId: Uuid().v1(),
      groupName: groupName,
      description: description,
      ownerId: currentUser.userId,
      autoExitDays: autoExitDays,
    );

    await groupRepository.registerGroup(group, currentUser);


  }

  onGroupRegistered(GroupRepository groupRepository) {

    //todo delete this method if not necessary
    _isProcessing = groupRepository.isProcessing;
    notifyListeners();

  }



}