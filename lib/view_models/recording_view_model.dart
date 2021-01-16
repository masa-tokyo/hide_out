import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class RecordingViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final GroupRepository groupRepository;
  final PostRepository postRepository;

  RecordingViewModel({this.userRepository, this.groupRepository, this.postRepository});

  bool isProcessing = false;

  String timeText = "00:01";
  String title = "";
  File audioFile;

  Future<void> postRecording(String path) async{
    isProcessing = true;
    notifyListeners();

    //todo pick audio file
    // audioFile = await

    //todo post

    print("post was done!");

    isProcessing = false;
    notifyListeners();

  }


}