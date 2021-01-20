import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class PostRepository {
  final DatabaseManager dbManager;

  PostRepository({this.dbManager});

  Future<void> postRecording(User currentUser,
      Group group,
      String title,
      File audioFile,
      String audioDuration,) async {
    //get audioUrl from Firebase Storage
    final storageId = Uuid().v1();
    final audioUrl = await dbManager.uploadAudioToStorage(audioFile, storageId);

    //post on Cloud Firestore
    final post = Post(
      postId: Uuid().v1(),
      userId: currentUser.userId,
      groupId: group.groupId,
      userName: currentUser.inAppUserName,
      title: title,
      audioUrl: audioUrl,
      audioStoragePath: storageId,
      audioDuration: audioDuration,
      postDateTime: DateTime.now(),);

    await dbManager.postRecording(post);

  }

  Future<List<Post>> getPostsByGroup(String groupId) async{
    return await dbManager.getPostsByGroup(groupId);

  }
}
