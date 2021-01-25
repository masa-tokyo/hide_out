import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class GroupRepository extends ChangeNotifier{
  final DatabaseManager dbManager;

  GroupRepository({this.dbManager});

  List<Group> _groups = <Group>[];
  List<Group> get groups => _groups;

  Group _group;
  Group get group => _group;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Future<void> registerGroup(Group group, User currentUser) async{
    await dbManager.registerGroup(group, currentUser);


  }

  //todo delete it after introducing alternative way of reading groups more than 10
  Future<bool> isNewGroupAvailable(User currentUser) async{
    return await dbManager.isNewGroupAvailable(currentUser.userId);
  }

   Future<void> getGroupsByUserId(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    _groups = await dbManager.getGroupsByUserId(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

   }

  Future<void> getGroupsExceptForMine(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    _groups = await dbManager.getGroupsExceptForMine(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> joinGroup(Group group, User currentUser) async{
    await dbManager.joinGroup(group.groupId, currentUser.userId);
  }

  Future<void> updateInfo(Group updatedGroup) async{
    await dbManager.updateGroupInfo(updatedGroup);
  }

  Future<void> getGroupInfo(String groupId) async{
    _isProcessing = true;
    notifyListeners();

    _group = await dbManager.getGroupInfoByGroupId(groupId);

    _isProcessing = false;
    notifyListeners();
  }

  Future<void> leaveGroup(Group group, User currentUser) async{
    await dbManager.leaveGroup(group.groupId, currentUser.userId);
  }



}
