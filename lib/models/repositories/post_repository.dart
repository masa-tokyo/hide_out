import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/%20data_models/report.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/database_manager.dart';
import 'package:uuid/uuid.dart';

class PostRepository extends ChangeNotifier {
  final DatabaseManager? dbManager;

  PostRepository({this.dbManager});

  List<Post> _posts = <Post>[];

  List<Post> get posts => _posts;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  Future<void> postRecording({
    required User currentUser,
    required String title,
    required File audioFile,
    required String audioDuration,
    List<String?>? groupIds,
    String? groupId,
  }) async {
    _isUploading = true; //for showing UploadingPage
    notifyListeners();

    // get audioUrl from Firebase Storage
    final storageId = Uuid().v1();
    final audioStoragePath = "posts/$storageId";
    final audioUrl =
        await dbManager!.uploadAudioToStorage(audioFile, audioStoragePath);

    if (groupId != null) {
      //post from GroupScreen
      final post = Post(
          postId: Uuid().v1(),
          userId: currentUser.userId,
          groupId: groupId,
          userName: currentUser.inAppUserName,
          title: title,
          audioUrl: audioUrl,
          audioStoragePath: audioStoragePath,
          audioDuration: audioDuration,
          postDateTime: DateTime.now().toUtc(),
          isListened: false,
          excludedUserIds: []);

      await dbManager!.postRecording(post, currentUser.userId, groupId);

      //show the newest on GroupScreen
      _posts
        ..add(post)
        ..sort((a, b) => b.postDateTime!.compareTo(a.postDateTime!));
    }

    if (groupIds != null) {
      //post from HomeScreen
      await Future.forEach(groupIds, (dynamic groupId) async {
        final post = Post(
            postId: Uuid().v1(),
            userId: currentUser.userId,
            groupId: groupId,
            userName: currentUser.inAppUserName,
            title: title,
            audioUrl: audioUrl,
            audioStoragePath: audioStoragePath,
            audioDuration: audioDuration,
            postDateTime: DateTime.now().toUtc(),
            isListened: false,
            excludedUserIds: []);

        await dbManager!.postRecording(post, currentUser.userId, groupId);
      });
    }
    _isUploading = false;
    notifyListeners();
  }

  Future<void> getPostsByGroup(String groupId, String userId) async {
    _isProcessing = true;
    notifyListeners();

    //not to show the posts of the previous group
    _posts.clear();

    _posts = await dbManager!.getPostsByGroup(groupId, userId);

    _isProcessing = false;
    notifyListeners();
  }

  Future<void> deletePost(Post post) async {
    await dbManager!.deletePost(post);
    _posts.removeWhere((element) => element.postId == post.postId);
    notifyListeners();
  }

  Future<void> removeMemberPost(Post post,
      {required String currentUserId}) async {
    await dbManager!.updatePost(currentUserId: currentUserId, post: post);
    _posts.removeWhere((element) => element.postId == post.postId);
    notifyListeners();
  }

  Future<void> reportMemberPost(Post post,
      {required String currentUserId}) async {
    final report = Report(
      reportId: Uuid().v1(),
      postId: post.postId!,
      postOwnerId: post.userId!,
      reporterId: currentUserId,
      postTitle: post.title!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await dbManager!.createReport(report);
  }

  Future<void> insertListener(Post post, User user) async {
    var updatedPost = post.copyWith(isListened: true);

    await dbManager!.insertListener(updatedPost, user);
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    return await dbManager!.getPostsByUser(userId);
  }
}
