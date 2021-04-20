
import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final AudioPlayManager audioPlayManager;

  GroupViewModel({this.groupRepository, this.postRepository, this.userRepository, this.audioPlayManager});

  User get currentUser => UserRepository.currentUser;

  String groupName = "";
  String description = "";

  List<Post> _posts = <Post>[];
  List<Post> get posts => _posts;

  Group _group;
  Group get group => _group;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<User> _groupMembers = [];
  List<User> get groupMembers => _groupMembers;


  bool _isAudioFinished = false;
  bool get isAudioFinished => _isAudioFinished;

  bool _isAnotherAudioPlaying = false;
  bool get isAnotherAudioPlaying => _isAnotherAudioPlaying;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int autoExitDays = 4;


  //-------------------------------------------------------------------------------------------------- Post Repository

  Future<void> getGroupPosts(Group group) async{

    await postRepository.getPostsByGroup(group.groupId);

  }
  onGroupPostsObtained(PostRepository postRepository) {
    _isProcessing = postRepository.isProcessing;
    _posts = postRepository.posts;
    notifyListeners();
  }

  Future<void> deletePost(Post post) async{
    await postRepository.deletePost(post.postId);
  }

  Future<void> insertListener(String postId) async{
    await postRepository.insertListener(postId, currentUser.userId);
  }

  Future<bool> isListened(Post post) async{
    return await postRepository.isListened(post.postId);
  }


  //-------------------------------------------------------------------------------------------------- Audio methods

  Future<void> playAudio(String audioUrl) async{

    await audioPlayManager.playAudio(audioUrl);

  }


  Future<void> pauseAudio() async{
    await audioPlayManager.pauseAudio();
  }

  Future<void> resumeAudio(String audioUrl) async{
    await audioPlayManager.playAudio(audioUrl);
  }


  onAudioFinished(AudioPlayManager audioPlayManager) {
    _isAudioFinished = audioPlayManager.isAudioFinished;
    notifyListeners();
  }

  Future<void> stopAnotherAudio() async{
    await audioPlayManager.stopAnotherAudio();
  }

  onAnotherPlayerStopped(AudioPlayManager audioPlayManager) {
    _isAnotherAudioPlaying = audioPlayManager.isAnotherAudioPlaying;
    _isPlaying = audioPlayManager.isPlaying;
    notifyListeners();
  }

  Future<void> updateStatus() async{
    await audioPlayManager.updateStatus();
  }

  onStatusUpdated(AudioPlayManager audioPlayManager) {
    _isPlaying = audioPlayManager.isPlaying;
    _isAnotherAudioPlaying = audioPlayManager.isPlaying;
    notifyListeners();
  }

  //-------------------------------------------------------------------------------------------------- Group Repository
  Future<void> getGroupInfo(String groupId) async{
    await groupRepository.getGroupInfo(groupId);
  }

  onGroupInfoObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _group = groupRepository.group;
    notifyListeners();
  }

  void updateAutoExitPeriod(int intDays) {
    autoExitDays = intDays;
    notifyListeners();
  }

  Future<void> updateGroupInfo(String groupId) async{
    await groupRepository.updateGroupInfo(group.copyWith(groupName: groupName, description: description, autoExitDays: autoExitDays));

    //in case of showing updated Auto-Exit Period
    await groupRepository.getGroupInfo(groupId);
  }

  onGroupInfoUpdated (GroupRepository groupRepository) {
    _group = groupRepository.group;
    notifyListeners();
  }

  Future<void> leaveGroup(Group group) async{
    await groupRepository.leaveGroup(group, currentUser);
  }

  Future<void> getMemberInfo(Group group) async{
    await userRepository.getUsersByGroupId(group);

  }

  onGroupMemberInfoObtained(UserRepository userRepository) {
    _isProcessing = userRepository.isProcessing;
    _groupMembers = userRepository.groupMembers;
    notifyListeners();

  }














}