import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final UserRepository userRepository;

  HomeScreenViewModel({this.groupRepository, this.userRepository});

  User get currentUser => UserRepository.currentUser;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  List<Group> _autoExitGroups = [];
  List<Group> get autoExitGroups => _autoExitGroups;

  List<String> _closedGroupNames = [];
  List<String> get closedGroupNames => _closedGroupNames;


  Future<void> getMyGroup() async{

    await groupRepository.getMyGroupWithAutoExitChecked(currentUser);


  }

  onMyGroupObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.myGroups;
    _autoExitGroups = groupRepository.autoExitGroups;
    _closedGroupNames = groupRepository.closedGroupNames;
    notifyListeners();
  }

  void deleteAutoExitGroup(Group confirmedGroup) {
    for (Group group in _autoExitGroups){
      if (group == confirmedGroup){
        _autoExitGroups.remove(group);
        groupRepository.deleteAutoExitGroup(group);
      }
      return;
    }

  }

  void deleteClosedGroupName(String confirmedGroupName) {
    for (String groupName in _closedGroupNames) {
      if (groupName == confirmedGroupName) {
        _closedGroupNames.remove(groupName);
        groupRepository.deleteClosedGroupName(currentUser, groupName);
      }
    }
  }



}