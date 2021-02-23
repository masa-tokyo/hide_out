
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
  final AudioPlayManager audioPlayManager;

  GroupViewModel({this.groupRepository, this.postRepository, this.audioPlayManager});

  User get currentUser => UserRepository.currentUser;

  String groupName = "";
  String description = "";

  List<Post> _posts = <Post>[];
  List<Post> get posts => _posts;

  Group _group;
  Group get group => _group;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isAudioFinished = false;
  bool get isAudioFinished => _isAudioFinished;

  bool _isAnotherAudioPlaying = false;
  bool get isAnotherAudioPlaying => _isAnotherAudioPlaying;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

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

  Future<void> updateGroupNameAndDescription() async{
    await groupRepository.updateInfo(group.copyWith(groupName: groupName, description: description));
  }

  Future<void> updateGroupName() async{
    await groupRepository.updateInfo(group.copyWith(groupName: groupName,));

  }

  Future<void> updateDescription() async{
    await groupRepository.updateInfo(group.copyWith(description: description));

  }

  Future<void> leaveGroup(Group group) async{
    await groupRepository.leaveGroup(group, currentUser);
  }










}