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

  List<Group> _deletedGroups = [];
  List<Group> get deletedGroups => _deletedGroups;


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

   Future<void> getGroupsByUserId(User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

   }

  Future<void> checkAutoExit(List<Group> groups, User currentUser) async{
    _isProcessing = true;
    notifyListeners();

    //since the list might have some data of the last time, empty it
    _deletedGroups.clear();

    await Future.forEach(groups, (group) async{

      var lastPostDateTime = await dbManager.getLastPostDateTime(group, currentUser.userId);


      //convert from Iso8601String to DateTime
      var lastPostDateTimeAsDateTime = DateTime.parse(lastPostDateTime);

      //calculate current DateTime - lastPostDateTime
      var subtraction = DateTime.now().difference(lastPostDateTimeAsDateTime).inDays;

      if(subtraction >= group.autoExitDays){
        //delete data
        await leaveGroup(group.groupId, currentUser);

        //add the deleted group on deletedGroups
        _deletedGroups.add(group);
      }

    });

    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);

    _isProcessing = false;
    notifyListeners();

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

    //update group information for MyGroup@HomeScreen
    _myGroups = await dbManager.getGroupsByUserId(currentUser.userId);
    notifyListeners();

  }


}
