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

  String timeText = "timeText";
  String title = "";
  File audioFile;

  Stopwatch _stopwatch = Stopwatch();

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

  Future<void> startStopwatch() async{
    _stopwatch.start();
    timeText = _stopwatch.elapsedTicks.toString();

    notifyListeners();

  }

  Future<void> finishStopwatch() async{
    _stopwatch.stop();
    timeText = _stopwatch.elapsedTicks.toString();

    notifyListeners();

  }

  Future <void> resetStopwatch() async{
    _stopwatch.reset();
    timeText = _stopwatch.elapsedTicks.toString();

    notifyListeners();

  }


}