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

  List<Group> groups = List();

  Future<void> getGroupsExceptForMine() async{
    groups = await groupRepository.getGroupsExceptForMine(currentUser);
    notifyListeners();


  }

  Future<void> joinGroup(Group group) async{
   await groupRepository.joinGroup(group, currentUser);
  }


}