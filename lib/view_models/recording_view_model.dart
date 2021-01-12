import 'package:flutter/material.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/utils/constants.dart';

class RecordingViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  RecordingViewModel({this.userRepository, this.groupRepository});

  RecordingButtonStatus recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;

  String title = "";

  Future<void> changeStatus() async{
    switch(recordingButtonStatus) {
      case RecordingButtonStatus.BEFORE_RECORDING:
        recordingButtonStatus = RecordingButtonStatus.DURING_RECORDING;
        break;
      case RecordingButtonStatus.DURING_RECORDING:
        recordingButtonStatus = RecordingButtonStatus.AFTER_RECORDING;
        break;
      case RecordingButtonStatus.AFTER_RECORDING:
        recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;
        break;
    }
    notifyListeners();
  }

}