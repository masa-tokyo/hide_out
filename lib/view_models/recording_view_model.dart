import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class RecordingViewModel extends ChangeNotifier{
  final GroupRepository groupRepository;
  final PostRepository postRepository;

  RecordingViewModel({this.groupRepository, this.postRepository});


  String title = "";
  File audioFile;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  User get currentUser => UserRepository.currentUser;


  Future<void> postRecording(String path, String audioDuration, Group group) async{

    //todo [check] filePicker necessary?
    // audioFile = await postRepository.pickAudioFile(path);
    audioFile = File(path);

    //post
    await postRepository.postRecording(
      currentUser,
      group,
      title,
      audioFile,
      audioDuration,
    );
  }

  onRecordingPosted(PostRepository postRepository) {
    _isProcessing = postRepository.isProcessing;
    notifyListeners();
  }



}