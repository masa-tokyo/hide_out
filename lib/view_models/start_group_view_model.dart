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

  String groupName = "";
  String description = "";

  Group group;

  //todo delete this method, update the property @view
  Future<void> updateGroupName(String groupNameString) async{
    groupName = groupNameString;
    notifyListeners();
  }

  Future<void> updateDescription(String descriptionString) async{
    description = descriptionString;
    notifyListeners();
  }

  Future<void> registerGroup() async{
    group = Group(
      groupId: Uuid().v1(),
      groupName: groupName,
      description: description,
      ownerId: currentUser.userId,
    );

    await userRepository.registerGroupIdOnUsers(group.groupId);
    await groupRepository.registerGroup(group, currentUser);


  }


}