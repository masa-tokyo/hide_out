import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/post_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/models/tracking.dart';
import 'package:hide_out/utils/constants.dart';

class RecordingViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;

  RecordingViewModel(
      {required this.groupRepository,
      required this.postRepository,
      required this.userRepository});

  String title = "";

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  bool _isTyping = false;

  bool get isTyping => _isTyping;

  List<Group> _groups = [];

  List<Group> get groups => _groups;

  RecordingButtonStatus _recordingButtonStatus =
      RecordingButtonStatus.BEFORE_RECORDING;

  RecordingButtonStatus get recordingButtonStatus => _recordingButtonStatus;

  List<String?> _groupIds = [];

  List<String?> get groupIds => _groupIds;

  bool _isPostRepositorySynced = false;

  bool get isPostRepositorySynced => _isPostRepositorySynced;

  User? get currentUser => UserRepository.currentUser;

  Future<void> postRecording(
      {required String path,
      required String audioDuration,
      String? currentGroupId}) async {
    //the order of methods @update properties in providers.dart matters
    //prevent _isUploading from being synced with userRepository.isUploading
    _isPostRepositorySynced = true;

    final audioFile = File(path);

    await postRepository.postRecording(
        currentUser: currentUser!,
        title: title,
        audioFile: audioFile,
        audioDuration: audioDuration,
        groupId: currentGroupId,
        groupIds: groupIds != [] ? groupIds : null);

    final totalPosts = await postRepository.getPostsByUser(currentUser!.userId);

      Tracking().logEvent(EventType.POST_TALK, eventParams: {
        'post_type': currentGroupId != null ? 'single' : 'multiple',
        'total_posts': totalPosts.length,
      });

      if(totalPosts.length == 1) {
        Tracking().logEvent(EventType.FIRST_POST_TALK, eventParams: {
        });
      }

    _groupIds.clear();

    _isPostRepositorySynced = false;
  }

  onRecordingPosted(PostRepository postRepository) {
    if (_isPostRepositorySynced) {
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

  Future<void> getMyGroup() async {
    await groupRepository.getMyGroup(currentUser!);
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

  Future<void> uploadSelfIntro(String path) async {
    await userRepository.uploadSelfIntro(path);
  }

  onSelfIntroUploaded(UserRepository userRepository) {
    if (!_isPostRepositorySynced) {
      _isUploading = userRepository.isUploading;
      notifyListeners();
    }
  }
}
