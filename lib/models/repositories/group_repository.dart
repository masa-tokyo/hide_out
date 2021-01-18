import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class GroupRepository {
  final DatabaseManager dbManager;

  GroupRepository({this.dbManager});

  static Group currentGroup;

  Future<void> registerGroup(Group group, User currentUser) async{
    await dbManager.registerGroup(group, currentUser);

    currentGroup = await dbManager.getGroupInfoByGroupId(group.groupId);

  }

   Future<List<Group>> getGroupsByUserId(User currentUser) async{
    return await dbManager.getGroupsByUserId(currentUser.userId);
   }

  Future<List<Group>> getGroupsExceptForMine(User currentUser) async{
    return await dbManager.getGroupsExceptForMine(currentUser.userId);
  }

  Future<void> joinGroup(Group group, User currentUser) async{
    await dbManager.joinGroup(group.groupId, currentUser.userId);
  }


}
