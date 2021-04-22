import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class GroupRepository extends ChangeNotifier{
  final DatabaseManager dbManager;

  GroupRepository({this.dbManager});

  List<Group> _myGroups = <Group>[];
  List<Group> get myGroups => _myGroups;

  List<Group> _otherGroups = <Group>[];
  List<Group> get otherGroups => _otherGroups;

  Group _group;
  Group get group => _group;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Group> _autoExitGroups = [];
  List<Group> get autoExitGroups => _autoExitGroups;

  List<String> _closedGroupNames = [];
  List<String> get closedGroupNames => _closedGroupNames;


  Future<void> registerGroup(Group group, User currentUser) async{
    await dbManager.registerGroup(group, currentUser);

    //update group information for MyGroup@HomeScreen & SendToGroupScreen
    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);
    notifyListeners();

  }

  //todo delete it after introducing alternative way of reading groups more than 10
  Future<bool> isNewGroupAvailable(User currentUser) async{
    return await dbManager.isNewGroupAvailable(currentUser.userId);
  }



  Future<void> getMyGroup(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);


    //check whether any group was closed by the owner
    _closedGroupNames = await dbManager.getClosedGroupNames(currentUser.userId);


    _isProcessing = false;
    notifyListeners();

  }

  Future<void> getMyGroupWithAutoExitChecked(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    //get groups from db once
    var groupsForNow = await dbManager.getGroupsByUserId(currentUser.userId);


    //check auto-exit period -->

    await Future.forEach(groupsForNow, (group) async{

      var lastPostDateTime = await dbManager.getLastPostDateTime(group, currentUser.userId);


      //convert from Iso8601String to DateTime
      var lastPostDateTimeAsDateTime = DateTime.parse(lastPostDateTime);

      //calculate current DateTime - lastPostDateTime
      var subtraction = DateTime.now().difference(lastPostDateTimeAsDateTime).inDays;

      if(subtraction >= group.autoExitDays){
        //delete data
        await leaveGroup(group, currentUser);

        //add the deleted group for showing dialog
        _autoExitGroups.add(group);
      }

    });

    // <--check auto-exit period


    //check whether any group was closed by the owner
    _closedGroupNames = await dbManager.getClosedGroupNames(currentUser.userId);


    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

  }

  void deleteAutoExitGroup(Group confirmedGroup) {
    _autoExitGroups.remove(group);
  }

  Future<void> deleteClosedGroupName(User currentUser, String groupName) async{
    _closedGroupNames.remove(groupName);
    await dbManager.deleteClosedGroupName(currentUser.userId, groupName);

  }


  Future<void> getGroupsExceptForMine(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    _otherGroups = await dbManager.getGroupsExceptForMine(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> joinGroup(List<Group> chosenGroups, User currentUser) async{

    chosenGroups.forEach((element) async {
      await dbManager.joinGroup(element.groupId, currentUser.userId);
    });

    //update group information for MyGroup@HomeScreen & SendToGroupScreen
    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);
    notifyListeners();

  }

  Future<void> updateGroupInfo(Group updatedGroup) async{
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

    //update group information for MyGroup@HomeScreen
    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);
    notifyListeners();

  }

  Future<Group> returnGroupInfo(String groupId) async{
    return await dbManager.getGroupInfoByGroupId(groupId);
  }

  Future<void> closeGroup(Group group, User currentUser) async{

    await dbManager.closeGroup(group.groupId, currentUser.userId,group.groupName);

    //update group information for MyGroup@HomeScreen
    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);

    notifyListeners();
  }




}
