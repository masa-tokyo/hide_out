import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';

class DatabaseManager {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


 //--------------------------------------------------------------------------------------------------Insert
  Future<void> insertUser(User user) async{
   await _db.collection("users").doc(user.userId).set(user.toMap());

  }

 Future<void> registerGroup(Group group, User currentUser) async{
    await _db.collection('groups').doc(group.groupId).set(group.toMap());

    //set userId on members collection
    await _db.collection("groups").doc(group.groupId)
        .collection("members").doc(currentUser.userId).set({"userId": currentUser.userId});
 }

  Future<void> registerGroupIdOnUsers(String groupId, String userId) async{
    await _db.collection("users").doc(userId).collection("groups").doc(groupId).set({"groupId": groupId});
  }

  Future<void> joinGroup(String groupId, String userId) async{
    //add groupId on "groups" in "users"
    await _db.collection("users").doc(userId)
        .collection("groups").doc(groupId).set({"groupId": groupId});

    //add userId on "members" in "groups"
    await _db.collection("groups").doc(groupId)
        .collection("members").doc(userId).set({"userId": userId});

  }

  //--------------------------------------------------------------------------------------------------Read

  Future<bool> searchUserInDb(auth.User firebaseUser) async{
    final query = await _db.collection("users").where("userId", isEqualTo: firebaseUser.uid).get();
    if (query.docs.length > 0) {
      return true;
    }
    return false;

  }

  Future<User> getUserInfoFromDbById(String userId) async{
    final query = await _db.collection("users").where("userId", isEqualTo: userId).get();
    return User.fromMap(query.docs[0].data());
  }

  Future<List<Group>> getGroupsByUserId(String userId) async{

    //get groupIds on "users"
    final queryOnUsers = await _db.collection("users").get();
    if (queryOnUsers.docs.length == 0) return List();

    var groupIds = await getGroupIds(userId);

    //get groups on "groups"
    final queryOnGroups = await _db.collection("groups").get();
    if (queryOnGroups.docs.length == 0) return List();

    var results = List<Group>();
    await _db.collection("groups").where("groupId", whereIn: groupIds).get()
    .then((value) {
      value.docs.forEach((element) {
        results.add(Group.fromMap(element.data()));
      });
    });

    return results;

//anyways to read like this??
    // var results = List<Group>();
    // await _db.collection("groups").where("members").where("userId", isEqualTo: userId).get()
    // .then((value) {
    //   value.docs.forEach((element) {
    //     results.add(Group.fromMap(element.data()));
    //   });
    // });
    //
    // return results;

  }

  Future<List<String>> getGroupIds(String userId) async{
    final query = await _db.collection("users").doc(userId).collection("groups").get();
    if(query.docs.length == 0) return List();

    var results = List<String>();
     query.docs.forEach((element) {
      results.add(element.data()["groupId"]);
    });
     return results;

  }

  Future<List<Group>> getGroupsExceptForMine(String userId) async{
    //get groupIds on "users" to exclude
    final queryOnUsers = await _db.collection("users").get();
    if (queryOnUsers.docs.length == 0) return List();

    var groupIds = await getGroupIds(userId);


    //get groups except for the ones currentUser already belongs to
    final queryOnGroups = await _db.collection("groups").get();
    if (queryOnGroups.docs.length == 0) return List();

    var results = List<Group>();
   
    await _db.collection("groups").where("groupId", whereNotIn: groupIds).get()
    .then((value) {
      value.docs.forEach((element) {
        results.add(Group.fromMap(element.data()));
      });
    });
 
    return results;

  }





//--------------------------------------------------------------------------------------------------Update





  //--------------------------------------------------------------------------------------------------Delete






}