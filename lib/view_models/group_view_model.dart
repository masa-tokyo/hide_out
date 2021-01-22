import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/repositories/post_repository.dart';

class GroupViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final AudioPlayManager audioPlayManager;

  GroupViewModel({this.postRepository, this.audioPlayManager});

  List<Post> _posts = <Post>[];
  List<Post> get posts => _posts;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isAudioFinished = false;
  bool get isAudioFinished => _isAudioFinished;


  Future<void> getGroupPosts(Group group) async{

    await postRepository.getPostsByGroup(group.groupId);

  }

  Future<void> playAudio(String audioUrl) async{

    await audioPlayManager.playAudio(audioUrl);

  }


  Future<void> pauseAudio() async{
    await audioPlayManager.pauseAudio();
  }

  Future<void> resumeAudio(String audioUrl) async{
    await audioPlayManager.playAudio(audioUrl);
  }


  @override
  void dispose() {
    super.dispose();
    audioPlayManager.dispose();
  }

  onGroupPostsObtained(PostRepository postRepository) {
    _isProcessing = postRepository.isProcessing;
    _posts = postRepository.posts;
    notifyListeners();
  }

  onAudioFinished(AudioPlayManager audioPlayManager) {
    _isAudioFinished = audioPlayManager.isAudioFinished;
    notifyListeners();
  }



}