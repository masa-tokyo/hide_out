import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';

class DatabaseManager {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


 //--------------------------------------------------------------------------------------------------Insert
  Future<void> insertUser(User user) async{
   await _db.collection("users").doc(user.userId).set(user.toMap());

  }

 Future<void> registerGroup(Group group, User currentUser) async{
    await _db.collection('groups').doc(group.groupId).set(group.toMap());

    //set userId and lastPostDateTime for small group on members collection
    await _db.collection("groups").doc(group.groupId)
        .collection("members").doc(currentUser.userId).set({"userId": currentUser.userId, "lastPostDateTime": DateTime.now().toIso8601String()});
 }

  Future<void> registerGroupIdOnUsers(String groupId, String userId) async{
    await _db.collection("users").doc(userId).collection("groups").doc(groupId).set({"groupId": groupId});
  }

  Future<void> joinGroup(String groupId, String userId) async{
    //add groupId on "groups" in "users"
    await _db.collection("users").doc(userId)
        .collection("groups").doc(groupId).set({"groupId": groupId});

    //add userId and lastPostDateTime on "members" in "groups"
    await _db.collection("groups").doc(groupId)
        .collection("members").doc(userId).set({"userId": userId, "lastPostDateTime": DateTime.now().toIso8601String()});

  }

  Future<String> uploadAudioToStorage(File audioFile, String storageId) async{
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    final uploadTask = storageRef.putFile(audioFile);
    final downloadUrl = uploadTask.then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
    return downloadUrl;
  }

 Future<void> postRecording(Post post, String userId, String groupId) async{
    await _db.collection("posts").doc(post.postId).set(post.toMap());

    //update lastPostDateTime at members collection of groups collection
   await _db.collection("groups").doc(groupId).collection("members").doc(userId).update({"userId": userId, "lastPostDateTime": DateTime.now().toIso8601String()});
 }

 Future<void> insertListener(String postId, String userId) async{
   //insert userId only once
   await _db.collection("posts").doc(postId).collection("listeners").doc(userId).set({"userId": userId});
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
    if (queryOnUsers.docs.length == 0) return [];

    var groupIds = await getGroupIds(userId);

    //get groups on "groups"
    final queryOnGroups = await _db.collection("groups").get();
    if (queryOnGroups.docs.length == 0) return [];

    var results = <Group>[];
    if(groupIds.length == 0) return []; //in the case that users left all groups
    await _db.collection("groups").where("groupId", whereIn: groupIds).limit(10).get()
    .then((value) {
      value.docs.forEach((element) {
        results.add(Group.fromMap(element.data()));
      });
    });

    return results;

  }

  Future<List<String>> getGroupIds(String userId) async{
    final query = await _db.collection("users").doc(userId).collection("groups").limit(10).get();
    if(query.docs.length == 0) return [];

    var results = <String>[];
     query.docs.forEach((element) {
      results.add(element.data()["groupId"]);
    });
     return results;

  }

  Future<List<Group>> getGroupsExceptForMine(String userId) async{
    //get groupIds on "users" to exclude
    final queryOnUsers = await _db.collection("users").get();
    if (queryOnUsers.docs.length == 0) return [];

    var groupIds = await getGroupIds(userId);


    //get groups except for the ones currentUser already belongs to
    final queryOnGroups = await _db.collection("groups").get();
    if (queryOnGroups.docs.length == 0) return [];

    var results = <Group>[];

    //if currentUser does not belong to any group, get all the groups
    if(groupIds.length == 0) {
      await _db.collection("groups").get()
                .then((value) {
                  value.docs.forEach((element) {
                    results.add(Group.fromMap(element.data()));
                  });
                });
    } else{
      await _db.collection("groups").where("groupId", whereNotIn: groupIds).get()
          .then((value) {
        value.docs.forEach((element) {
          results.add(Group.fromMap(element.data()));
        });
      });

    }

    return results;

  }

 Future<Group> getGroupInfoByGroupId(String groupId) async{
    final query = await _db.collection("groups").where("groupId", isEqualTo: groupId).get();
    return Group.fromMap(query.docs[0].data());
 }

 Future<List<Post>> getPostsByGroup(String groupId) async{
    final query = await _db.collection("posts").get();
    if (query.docs.length == 0) return [];

    var results = <Post>[];

    await _db.collection("posts").where("groupId", isEqualTo: groupId).orderBy("postDateTime", descending: true).get()
    .then((value) {
      value.docs.forEach((element) {
        results.add(Post.fromMap(element.data()));
      });
    });

    return results;

 }

  Future<bool> isNewGroupAvailable(String userId) async{
    final query = await _db.collection("users").doc(userId).collection("groups").get();
    if(query.docs.length <= 10) return true;
    return false;
  }

  Future<bool> isListened(String postId) async{
    final query = await _db.collection("posts").doc(postId).collection("listeners").get();
    if(query.docs.length == 0) return false;
    return true;

  }


  Future<List<User>> getUsersByGroupId(String groupId) async{
    //get userIds at members of groups
   final query = await _db.collection("groups").doc(groupId).collection("members").get();
   if(query.docs.isEmpty) return <User>[];

    var userIds = <String>[];
    query.docs.forEach((element) {
      userIds.add(element.data()["userId"]);
    });


    //get List of User at users
   var groupMembers = <User>[];

   await Future.forEach(userIds, (userId) async{
     final user = await getUserInfoFromDbById(userId);
     groupMembers.add(user);
   });

   return groupMembers;

  }

  Future<String> getLastPostDateTime(Group group, String userId) async{

    //get member doc at groups collection by groupId and userId
    var member = await _db.collection("groups").doc(group.groupId).collection("members").doc(userId).get();

    //get value from Map
    return member["lastPostDateTime"];


  }


  //--------------------------------------------------------------------------------------------------Update

  Future<void> updateGroupInfo(Group updatedGroup) async{
    await _db.collection("groups").doc(updatedGroup.groupId).update(updatedGroup.toMap());
  }


 Future<void> updateUserInfo(User user) async{
    await _db.collection("users").doc(user.userId).update(user.toMap());
 }

  //--------------------------------------------------------------------------------------------------Delete

 Future<void> leaveGroup(String groupId, String userId) async{
    //delete members at groups
   await _db.collection("groups").doc(groupId).collection("members").doc(userId).delete();

   //delete groupId at users
   await _db.collection("users").doc(userId).collection("groups").doc(groupId).delete();

 }

 Future<void> deletePost(String postId) async{

   //delete "listeners" first
   await _db.collection("posts").doc(postId).collection("listeners").get().then((value) {
     for (DocumentSnapshot doc in value.docs){
      doc.reference.delete();
     }
   });

   //delete post
    await _db.collection("posts").doc(postId).delete();
 }





}