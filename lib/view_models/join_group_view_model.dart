import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/models/tracking.dart';
import 'package:hide_out/utils/constants.dart';

class JoinGroupViewModel extends ChangeNotifier {
  final UserRepository? userRepository;
  final GroupRepository? groupRepository;

  JoinGroupViewModel({this.userRepository, this.groupRepository});

  User? get currentUser => UserRepository.currentUser;

  List<Group> _groups = <Group>[];
  List<Group> get groups => _groups;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Group> _chosenGroups = <Group>[];
  List<Group> get chosenGroups => _chosenGroups;


  Future<void> getGroupsExceptForMine() async{
    await groupRepository!.getGroupsExceptForMine(currentUser!);


  }

  Future<void> joinGroup() async{
   await groupRepository!.joinGroup(chosenGroups, currentUser!);
   Tracking().logEvent(EventType.JOIN_GROUP);

   _chosenGroups = [];

  }

  onGroupsExceptForMineObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.otherGroups;
    notifyListeners();
  }

  Future<void> chooseGroup(Group group) async{
    if (!_chosenGroups.contains(group)){
      _chosenGroups.add(group);
    } else {
      _chosenGroups.remove(group);
    }
    notifyListeners();
  }








}