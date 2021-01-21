import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class JoinGroupViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  JoinGroupViewModel({this.userRepository, this.groupRepository});

  User get currentUser => UserRepository.currentUser;

  List<Group> _groups = <Group>[];
  List<Group> get groups => _groups;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;



  Future<void> getGroupsExceptForMine() async{
    await groupRepository.getGroupsExceptForMine(currentUser);


  }

  Future<void> joinGroup(Group group) async{
   await groupRepository.joinGroup(group, currentUser);
  }

  onGroupsExceptForMineObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.groups;
    notifyListeners();

  }


}