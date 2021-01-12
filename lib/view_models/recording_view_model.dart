import 'package:flutter/material.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class RecordingViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  RecordingViewModel({this.userRepository, this.groupRepository});


  String title = "";

}