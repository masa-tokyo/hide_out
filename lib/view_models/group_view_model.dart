
import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class GroupViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final AudioPlayManager audioPlayManager;

  GroupViewModel({this.postRepository, this.audioPlayManager});

  User get currentUser => UserRepository.currentUser;

  List<Post> _posts = <Post>[];
  List<Post> get posts => _posts;

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



}