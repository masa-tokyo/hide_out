import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/utils/constants.dart';

class RecordingViewModel extends ChangeNotifier{
  final GroupRepository? groupRepository;
  final PostRepository? postRepository;
  final UserRepository? userRepository;

  RecordingViewModel({this.groupRepository, this.postRepository, this.userRepository});


  String title = "";

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  RecordingButtonStatus _recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;
  RecordingButtonStatus get recordingButtonStatus => _recordingButtonStatus;

  List<String?> _groupIds = [];
  List<String?> get groupIds => _groupIds;

  bool _isPostRepositorySynced = false;
  bool get isPostRepositorySynced => _isPostRepositorySynced;

  User? get currentUser => UserRepository.currentUser;


  Future<void> postRecording(String path, String audioDuration) async{
    //the order of methods @update properties in providers.dart matters
    //prevent _isUploading from being synced with userRepository.isUploading
    _isPostRepositorySynced = true;

    final audioFile = File(path);

    await Future.forEach(_groupIds, (dynamic groupId) async{

      await postRepository!.postRecording(
        currentUser!,
        groupId,
        title,
        audioFile,
        audioDuration,
      );
    });

   _groupIds.clear();

    _isPostRepositorySynced = false;
  }

  onRecordingPosted(PostRepository postRepository) {

    if(_isPostRepositorySynced){
      _isUploading = postRepository.isUploading;
      notifyListeners();
    }
  }


  void clearGroupIds() {
    _groupIds.clear();
  }


  updateRecordingButtonStatus(RecordingButtonStatus recordingButtonStatus) {
    _recordingButtonStatus = recordingButtonStatus;

  }

  Future<void> getMyGroup() async{
    await groupRepository!.getMyGroup(currentUser!);
  }

  onMyGroupObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.myGroups;

    notifyListeners();
  }

  void removeGroupId(String? groupId) {
    _groupIds.remove(groupId);
    notifyListeners();
  }

  void addGroupId(String? groupId) {
    _groupIds.add(groupId);
    notifyListeners();
  }

 void updateForNotTyping() {
    _isTyping = false;
    notifyListeners();
 }

  void updateForTyping() {
    _isTyping = true;
    notifyListeners();
  }


  Future <void> uploadSelfIntro(String path) async {

    await userRepository!.uploadSelfIntro(path);

  }

  onSelfIntroUploaded (UserRepository userRepository) {
    if(!_isPostRepositorySynced){
      _isUploading = userRepository.isUploading;
      notifyListeners();
    }

  }






}