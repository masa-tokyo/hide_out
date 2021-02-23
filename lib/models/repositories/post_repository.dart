import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class PostRepository extends ChangeNotifier{
  final DatabaseManager dbManager;

  PostRepository({this.dbManager});

  List<Post> _posts = <Post>[];
  List<Post> get posts => _posts;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;


  Future<void> postRecording(User currentUser,
      String groupId,
      String title,
      File audioFile,
      String audioDuration,) async {
    _isProcessing = true;
    notifyListeners();

    //get audioUrl from Firebase Storage
    final storageId = Uuid().v1();
    final audioUrl = await dbManager.uploadAudioToStorage(audioFile, storageId);

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
      postDateTime: DateTime.now(),);

    await dbManager.postRecording(post);

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> getPostsByGroup(String groupId) async{
    _isProcessing = true;
    notifyListeners();

    _posts = await dbManager.getPostsByGroup(groupId);

    _isProcessing = false;
    notifyListeners();


  }

 Future<void> deletePost(String postId) async{
    await dbManager.deletePost(postId);
 }
}
