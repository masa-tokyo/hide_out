import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/member.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/%20data_models/user.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //----------------------------------------------------------------------------Insert
  Future<void> insertUser(User user) async {
    await _db.collection("users").doc(user.userId).set(user.toMap());
  }

  Future<void> registerGroup(Group group, User currentUser) async {
    await _db.collection('groups').doc(group.groupId).set(group.toMap());

    //set data on sub-collection
    await _db
        .collection("groups")
        .doc(group.groupId)
        .collection("members")
        .doc(currentUser.userId)
        .set(Member(
                createdAt: DateTime.now(),
                isAlerted: false,
                lastPostDateTime: DateTime.now(),
                timeZoneOffsetInMinutes:
                    DateTime.now().timeZoneOffset.inMinutes,
                userId: currentUser.userId,
                name: currentUser.inAppUserName,
                photoUrl: currentUser.photoUrl)
            .toMap());
  }

  Future<void> registerGroupIdOnUsers(String? groupId, String? userId) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc(groupId)
        .set({"groupId": groupId});
  }

  Future<void> joinGroup(Group group, User user) async {
    //add groupId on "groups" in "users"
    await _db
        .collection("users")
        .doc(user.userId)
        .collection("groups")
        .doc(group.groupId)
        .set({"groupId": group.groupId});

    //add data on sub-collection
    final groupRef = _db.collection('groups').doc(group.groupId);

    await groupRef.collection("members").doc(user.userId).set(Member(
            createdAt: DateTime.now(),
            isAlerted: false,
            lastPostDateTime: DateTime.now(),
            timeZoneOffsetInMinutes: DateTime.now().timeZoneOffset.inMinutes,
            userId: user.userId,
            name: user.inAppUserName,
            photoUrl: user.photoUrl)
        .toMap());

    //update owner info if there are no other members
    if (group.ownerId == null) {
      groupRef.update(group
          .copyWith(
            ownerId: user.userId,
            ownerPhotoUrl: user.photoUrl,
          )
          .toMap());
    }
  }

  Future<String> uploadAudioToStorage(
      File audioFile, String storagePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    // specify the file type to prevent Android uploading "audio/X-HX-AAC-ADTS"
    final uploadTask = storageRef.putFile(
        audioFile,
        SettableMetadata(
          contentType: "audio/aac",
        ));
    final downloadUrl = uploadTask
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());

    return downloadUrl;
  }

  Future<String> uploadPhotoToStorage(
      File imageFile, String storagePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    final uploadTask = storageRef.putFile(imageFile);
    final downloadUrl = uploadTask
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());

    return downloadUrl;
  }

  Future<void> postRecording(Post post, String userId, String groupId) async {
    await _db.collection("posts").doc(post.postId).set(post.toMap());

    //update data on members collection
    updateMemberInfo(
        groupId: groupId,
        userId: userId,
        lastPostDateTime: DateTime.now().toUtc(),
        timeZoneOffsetInMinutes: DateTime.now().timeZoneOffset.inMinutes,
        isAlerted: false);
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

  Future<void> createDeleteAccountTrigger(User user) async {
    await _db
        .collection("triggers")
        .doc(user.userId)
        .collection("delete_account")
        //do not set userId as document Id in case that the same user
        //deletes account several times and a new document is not made,
        //which prevents the onCreate method from being called
        .add({
      "userId": user.userId,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    });
  }

  //-----------------------------------------------------------------------------Read

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
    final query =
        await _db.collection("users").doc(userId).collection("groups").get();

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
        //remove some groups that are not necessary for now
        results = _removeTopicGroups(results);
      });
    });

    return results;
  }

  List<Group> _removeTopicGroups(List<Group> results) {
    final topicGroupIds = [
      "00cfff40-7673-11eb-80dc-7138d5ef930f",
      "26581cd0-8734-11eb-8bc9-5145735be640",
      "3bd37d30-7671-11eb-8292-fbe39462078a",
      "538ce750-7670-11eb-b220-6978360019b1",
      "8cf727a0-766e-11eb-bdaa-7bed10e9b80d",
      "b3d1fbf0-7670-11eb-b29f-0f73c644dd79",
    ];

    results.removeWhere((element) => topicGroupIds.contains(element.groupId));

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
          ownerPhotoUrl: null,
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
    final query = await _db
        .collection("notifications")
        .where('userId', isEqualTo: userId)
        .get();
    if (query.docs.length == 0) return [];

    var results = <d.Notification>[];
    query.docs.forEach((doc) {
      results.add(d.Notification.fromMap(doc.data()));
    });

    return results;
  }

  Future<bool> isAccountDeleted(String uid) async {
    final query = await _db
        .collection('triggers')
        .doc(uid)
        .collection('delete_account')
        .get();

    if (query.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> fetchUser(String memberId) async {
    final user =
        await _db.collection('users').doc(memberId).get().then((value) {
      if (value.data() == null) {
        return User(
            userId: '',
            displayName: '',
            inAppUserName: 'Unknown User',
            photoUrl: '',
            photoStoragePath: '',
            audioUrl: '',
            audioStoragePath: '',
            email: '',
            createdAt: 0);
      }
      print('not null');
      return User.fromMap(value.data()!);
    });

    return user;
  }

  //-----------------------------------------------------------------------------Update

  Future<void> updateGroupInfo(Group updatedGroup) async {
    await _db
        .collection("groups")
        .doc(updatedGroup.groupId)
        .update(updatedGroup.toMap());
  }

  Future<void> updateUserInfo(User user,
      {bool isNameUpdated = false, bool isPhotoUpdated = false}) async {
    await _db.collection("users").doc(user.userId).update(user.toMap());

    if (isPhotoUpdated) {
      //update photoUrl on members
      final groupIds = await getGroupIds(user.userId);
      groupIds.forEach((groupId) {
        if (groupId == null) {
          return;
        }
        updateMemberInfo(
            groupId: groupId, userId: user.userId, photoUrl: user.photoUrl);
      });
    }

    if (isNameUpdated) {
      //update name on members
      final groupIds = await getGroupIds(user.userId);
      groupIds.forEach((groupId) {
        if (groupId == null) {
          return;
        }
        updateMemberInfo(
            groupId: groupId, userId: user.userId, name: user.inAppUserName);
      });

      //update userName on posts
      _db
          .collection("posts")
          .where("userId", isEqualTo: user.userId)
          .get()
          .then((posts) {
        posts.docs.forEach((post) {
          post.reference.update({"userName": user.inAppUserName});
        });
      });

      //update userName on listeners
      groupIds.forEach((groupId) {
        _db
            .collection("posts")
            .where("groupId", isEqualTo: groupId)
            .get()
            .then((posts) {
          posts.docs.forEach((post) {
            _db
                .collection("posts")
                .doc(post.id)
                .collection("listeners")
                .where("userId", isEqualTo: user.userId)
                .get()
                .then((listeners) {
              listeners.docs.forEach((listener) {
                listener.reference.update({"userName": user.inAppUserName});
              });
            });
          });
        });
      });
    }
  }

  Future<void> updateMemberInfo({
    required String groupId,
    required String userId,
    bool? isAlerted,
    DateTime? lastPostDateTime,
    int? timeZoneOffsetInMinutes,
    String? name,
    String? photoUrl,
  }) async {
    //point out what to update
    final map = <String, dynamic>{};

    if (isAlerted != null) {
      map.addAll({'isAlerted': isAlerted});
    }
    if (lastPostDateTime != null) {
      map.addAll({'lastPostDateTime': lastPostDateTime.toIso8601String()});
    }

    if (timeZoneOffsetInMinutes != null) {
      map.addAll({'timeZoneOffsetInMinutes': timeZoneOffsetInMinutes});
    }

    if (name != null) {
      map.addAll({'name': name});
    }
    if (photoUrl != null) {
      map.addAll({'photoUrl': photoUrl});
    }

    await _db
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(userId)
        .update(map);
  }

  //----------------------------------------------------------------------------Delete

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

  Future<void> deletePost(Post post) async {
    //delete "listeners" first
    await _db
        .collection("posts")
        .doc(post.postId)
        .collection("listeners")
        .get()
        .then((value) {
      for (DocumentSnapshot doc in value.docs) {
        doc.reference.delete();
      }
    });

    //delete post
    await _db.collection("posts").doc(post.postId).delete();

    //on storage
    if (post.audioStoragePath != null) {
      deleteFileOnStorage(post.audioStoragePath!);
    }
  }

  Future<void> deleteGroup(Group group, String? userId) async {
    //delete group doc itself as well as members sub-collection
    await _db.collection("groups").doc(group.groupId).delete();
  }

  Future<void> deleteNotification({required String? notificationId}) async {
    await _db.collection("notifications").doc(notificationId).delete();
  }

  Future<void> deleteNotificationByPostIdAndUserId(
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

  Future<void> deleteFileOnStorage(String storagePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    storageRef.delete();
  }
}
