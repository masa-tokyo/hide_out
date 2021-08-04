import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';
import 'package:voice_put/utils/constants.dart';

class PostRepository extends ChangeNotifier {
  final DatabaseManager? dbManager;

  PostRepository({this.dbManager});

  List<Post> _posts = <Post>[];

  List<Post> get posts => _posts;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  Future<void> postRecording(
    User currentUser,
    String? groupId,
    String title,
    File audioFile,
    String audioDuration,
  ) async {
    _isUploading = true;
    notifyListeners();

    // get audioUrl from Firebase Storage
    final storageId = Uuid().v1();
    final audioUrl =
        await dbManager!.uploadAudioToStorage(audioFile, storageId);

    //post on Cloud Firestore
    final post = Post(
        postId: Uuid().v1(),
        userId: currentUser.userId,
        groupId: groupId,
        userName: currentUser.inAppUserName,
        title: title,
        audioUrl: audioUrl,
        audioStoragePath: storageId,
        audioDuration: audioDuration,
        postDateTime: DateTime.now(),
        isListened: false);

    await dbManager!.postRecording(post, currentUser.userId, groupId);

    //update lastActivityAt @groups collection
    await dbManager!.updateLastActivityAt(groupId);

    //insert notification
    final members = await dbManager!.getUsersByGroupId(groupId);
    members.removeWhere((element) => element.userId == currentUser.userId);
    await Future.forEach(members, (dynamic member) async {
      await dbManager!.insertNotification(
          notificationType: NotificationType.NEW_POST,
          userId: member.userId,
          postId: post.postId,
          groupId: groupId,
          content: "${post.title}");
    });

    _isUploading = false;
    notifyListeners();
  }

  Future<void> getPostsByGroup(String? groupId) async {
    _isProcessing = true;
    notifyListeners();

    //not to show the posts of the previous group
    _posts.clear();

    _posts = await dbManager!.getPostsByGroup(groupId);

    _isProcessing = false;
    notifyListeners();
  }

  Future<void> deletePost(String? postId) async {
    await dbManager!.deletePost(postId);
    _posts.removeWhere((element) => element.postId == postId);
    notifyListeners();
  }

  Future<void> insertListener(Post post, User user) async {
    var updatedPost = post.copyWith(isListened: true);

    await dbManager!.insertListener(updatedPost, user);
  }
}
