import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/notification.dart' as d;
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/utils/constants.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //--------------------------------------------------------------------------------------------------Insert
  Future<void> insertUser(User user) async {
    await _db.collection("users").doc(user.userId).set(user.toMap());
  }

  Future<void> registerGroup(Group group, User currentUser) async {
    await _db.collection('groups').doc(group.groupId).set(group.toMap());

    //set userId and lastPostDateTime for small group on members collection
    await _db
        .collection("groups")
        .doc(group.groupId)
        .collection("members")
        .doc(currentUser.userId)
        .set({
      "userId": currentUser.userId,
      "lastPostDateTime": DateTime.now().toIso8601String()
    });
  }

  Future<void> registerGroupIdOnUsers(String? groupId, String? userId) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc(groupId)
        .set({"groupId": groupId});
  }

  Future<void> joinGroup(String? groupId, String? userId) async {
    //add groupId on "groups" in "users"
    await _db
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc(groupId)
        .set({"groupId": groupId});

    //add userId and lastPostDateTime on "members" in "groups"
    await _db
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(userId)
        .set({
      "userId": userId,
      "lastPostDateTime": DateTime.now().toIso8601String()
    });
  }

  Future<String> uploadAudioToStorage(File audioFile, String storageId) async {
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    final uploadTask = storageRef.putFile(audioFile);
    final downloadUrl = uploadTask
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<void> postRecording(Post post, String? userId, String? groupId) async {
    await _db.collection("posts").doc(post.postId).set(post.toMap());

    //update lastPostDateTime at members collection of groups collection
    await _db
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(userId)
        .update({
      "userId": userId,
      "lastPostDateTime": DateTime.now().toIso8601String()
    });
  }

  Future<void> insertListener(Post post, User user) async {
    //insert userId only once
    await _db
        .collection("posts")
        .doc(post.postId)
        .collection("listeners")
        .doc(user.userId)
        .set({
      "userId": user.userId,
      "userName": user.inAppUserName,
    });

    //update isListened
    await _db.collection("posts").doc(post.postId).update(post.toMap());
  }

  Future<void> insertClosedGroupOnMember(
      String groupId, String groupName, List<String> userIds) async {
    userIds.forEach((userId) async {
      await _db
          .collection("users")
          .doc(userId)
          .collection("closedGroups")
          .doc(groupId)
          .set({
        "groupId": groupId,
        "groupName": groupName,
      });
    });
  }

  Future<void> insertNotification({
    required notificationType,
    required userId,
    required postId,
    required groupId,
    required content,
  }) async {
    final notificationId = Uuid().v1();
    final notification = d.Notification(
        notificationType: notificationType,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        notificationId: notificationId,
        userId: userId,
        postId: postId,
        groupId: groupId,
        content: content);
    await _db
        .collection("notifications")
        .doc(notificationId)
        .set(notification.toMap());
  }

  //--------------------------------------------------------------------------------------------------Read

  Future<bool> searchUserInDb(auth.User firebaseUser) async {
    final query = await _db
        .collection("users")
        .where("userId", isEqualTo: firebaseUser.uid)
        .get();
    if (query.docs.length > 0) {
      return true;
    }
    return false;
  }

  Future<User> getUserInfoFromDbById(String? userId) async {
    final query =
        await _db.collection("users").where("userId", isEqualTo: userId).get();
    return User.fromMap(query.docs[0].data());
  }

  Future<List<Group>> getGroupsByUserId(String? userId) async {
    //get groupIds on "users"
    final queryOnUsers = await _db.collection("users").get();
    if (queryOnUsers.docs.length == 0) return [];

    var groupIds = await getGroupIds(userId);

    //get groups on "groups"
    final queryOnGroups = await _db.collection("groups").get();
    if (queryOnGroups.docs.length == 0) return [];

    var results = <Group>[];
    if (groupIds.length == 0)
      return []; //in the case that users left all groups
    await _db
        .collection("groups")
        .where("groupId", whereIn: groupIds)
        .limit(10)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Group.fromMap(element.data()));
      });
    });

    return results;
  }

  Future<List<String?>> getGroupIds(String? userId) async {
    final query = await _db
        .collection("users")
        .doc(userId)
        .collection("groups")
        .limit(10)
        .get();
    if (query.docs.length == 0) return [];

    var results = <String?>[];
    query.docs.forEach((element) {
      results.add(element.data()["groupId"]);
    });
    return results;
  }

  Future<List<Group>> getGroupsExceptForMine(String? userId) async {
    //get groupIds on "users" to exclude
    var groupIds = await getGroupIds(userId);

    final query = await _db.collection("groups").get();
    if (query.docs.length == 0) return [];

    var results = <Group>[];

      await _db
          .collection("groups")
          .orderBy("lastActivityAt", descending: true)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          results.add(Group.fromMap(element.data()));
          //remove the groups that currentUser already belongs to
          results.removeWhere((element) => groupIds.contains(element.groupId));

        });
      });


    return results;
  }

  Future<Group> getGroupInfoByGroupId(String? groupId) async {
    final query = await _db
        .collection("groups")
        .where("groupId", isEqualTo: groupId)
        .get();

    if (query.docs.isEmpty) {
      //in case when members choose a group which is already deleted by the owner
      final Group group = Group(
          groupId: groupId,
          groupName: "No Group",
          description: null,
          ownerId: null,
          autoExitDays: null,
          createdAt: null,
          lastActivityAt: null);

      return group;
    }

    return Group.fromMap(query.docs[0].data());
  }

  Future<List<Post>> getPostsByGroup(String? groupId) async {
    final query = await _db.collection("posts").get();
    if (query.docs.length == 0) return [];

    var results = <Post>[];

    await _db
        .collection("posts")
        .where("groupId", isEqualTo: groupId)
        .orderBy("postDateTime", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Post.fromMap(element.data()));
      });
    });

    return results;
  }

  Future<List<Post>> getPostsByUserIdAndGroupId(String? userId, groupId) async {
    final query = await _db.collection("posts").get();
    if (query.docs.isEmpty) return [];

    var posts = <Post>[];

    await _db
        .collection("posts")
        .where("userId", isEqualTo: userId)
        .where("groupId", isEqualTo: groupId)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        posts.add(Post.fromMap(doc.data()));
      });
    });

    return posts;
  }

  Future<bool> isNewGroupAvailable(String? userId) async {
    final query =
        await _db.collection("users").doc(userId).collection("groups").get();
    if (query.docs.length <= 10) return true;
    return false;
  }

  Future<List<User>> getUsersByGroupId(String? groupId) async {
    //get userIds at members of groups
    var userIds = await getUserIdsByGroupId(groupId);

    //get List of User at users
    var groupMembers = <User>[];

    await Future.forEach(userIds, (dynamic userId) async {
      final user = await getUserInfoFromDbById(userId);
      groupMembers.add(user);
    });

    return groupMembers;
  }

  Future<List<String?>> getUserIdsByGroupId(String? groupId) async {
    final query =
        await _db.collection("groups").doc(groupId).collection("members").get();
    if (query.docs.isEmpty) return <String>[];

    var userIds = <String?>[];

    query.docs.forEach((element) {
      userIds.add(element.data()["userId"]);
    });

    return userIds;
  }

  Future<List<String?>> getClosedGroupNames(String userId) async {
    final query = await _db
        .collection("users")
        .doc(userId)
        .collection("closedGroups")
        .get();
    if (query.docs.isEmpty) return [];

    var groupNames = <String?>[];

    query.docs.forEach((element) {
      groupNames.add(element.data()["groupName"]);
    });

    return groupNames;
  }

  Future<List<d.Notification>> getNotifications(String? userId) async {
    final query = await _db.collection("notifications").get();
    if (query.docs.length == 0) return [];

    var results = <d.Notification>[];
    query.docs
        .where((element) => element.data()["userId"] == userId)
        .forEach((doc) {
      results.add(d.Notification.fromMap(doc.data()));
    });

    return results;
  }

  //--------------------------------------------------------------------------------------------------Update

  Future<void> updateGroupInfo(Group updatedGroup) async {
    await _db
        .collection("groups")
        .doc(updatedGroup.groupId)
        .update(updatedGroup.toMap());
  }

  Future<void> updateUserInfo(User user) async {
    await _db.collection("users").doc(user.userId).update(user.toMap());
  }

  Future<void> updateLastActivityAt(String? groupId) async{
    await _db.collection("groups").doc(groupId).update(
      {"lastActivityAt": DateTime.now().millisecondsSinceEpoch,
      }
    );
  }


  //--------------------------------------------------------------------------------------------------Delete

  Future<void> leaveGroup(String? groupId, String? userId) async {
    //delete their own data at members of groups
    await _db
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(userId)
        .delete();

    //delete groupId at users
    await _db
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc(groupId)
        .delete();
  }

  Future<void> deletePost(String? postId) async {
    //delete "listeners" first
    await _db
        .collection("posts")
        .doc(postId)
        .collection("listeners")
        .get()
        .then((value) {
      for (DocumentSnapshot doc in value.docs) {
        doc.reference.delete();
      }
    });

    //delete post
    await _db.collection("posts").doc(postId).delete();
  }

  Future<void> deleteGroup(
      Group group, String? userId) async {





    //@posts collection

    //get all the userIds at members collection of groups collection
    var userIds = await getUserIdsByGroupId(group.groupId);

    //get posts of every user
    var posts = <Post>[];

    await Future.forEach(userIds, (dynamic userId) async {
      var postsByEachUser = <Post>[];

      //only posts in group doc are necessary
      postsByEachUser = await getPostsByUserIdAndGroupId(userId, group.groupId);

      postsByEachUser.forEach((element) {
        posts.add(element);
      });
    });

    posts.forEach((post) async {
      await deletePost(post.postId);
    });

    //@groups collection

    //delete members collection
    await _db
        .collection("groups")
        .doc(group.groupId)
        .collection("members")
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    //delete group doc itself
    await _db.collection("groups").doc(group.groupId).delete();

    //@users collection
    userIds.forEach((userId) async {
      await _db
          .collection("users")
          .doc(userId)
          .collection("groups")
          .doc(group.groupId)
          .delete();
    });


    //insert notification
    var memberIds = userIds;
    memberIds.removeWhere((element) => element == userId);

    await Future.forEach(memberIds, (dynamic element) {
      insertNotification(
          notificationType: NotificationType.DELETED_GROUP,
          userId: element,
          postId: "",
          groupId: "",
          content: group.groupName);
    });


  }

  Future<void> deleteNotification({required String? notificationId}) async {
    await _db.collection("notifications").doc(notificationId).delete();
  }

  deleteNotificationByPostIdAndUserId(
      {required String? postId, required String? userId}) async {
    await _db
        .collection("notifications")
        .where("postId", isEqualTo: postId)
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  deleteNotificationByGroupIdAndUserId(
      {required String? groupId, required String? userId}) async {
    await _db
        .collection("notifications")
        .where("groupId", isEqualTo: groupId)
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  deleteNotificationByPostId({
    required String? postId,
  }) async {
    await _db
        .collection("notifications")
        .where("postId", isEqualTo: postId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  deleteNotificationByGroupId({
    required String? groupId,
  }) async {
    await _db
        .collection("notifications")
        .where("groupId", isEqualTo: groupId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

}
