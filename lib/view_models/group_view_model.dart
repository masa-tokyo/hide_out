import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class GroupViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final GroupRepository groupRepository;
  final PostRepository postRepository;
  final AudioPlayManager audioPlayManager;

  GroupViewModel({this.postRepository, this.groupRepository, this.userRepository, this.audioPlayManager});

  List<Post> posts = <Post>[];

  bool isLoading = false;

  Future<void> getGroupPosts(Group group) async{
    isLoading = true;
    notifyListeners();

    posts = await postRepository.getPostsByGroup(group.groupId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> playAudio(String audioUrl) async{

    await _prepareAudio(audioUrl);
    await audioPlayManager.playAudio();

  }

  Future<void> _prepareAudio(String audioUrl) async{
    await audioPlayManager.prepareAudio(audioUrl);
  }

  Future<void> pauseAudio() async{
    await audioPlayManager.pauseAudio();
  }

  Future<void> resumeAudio() async{
    await audioPlayManager.playAudio();
  }


  @override
  void dispose() {
    super.dispose();
    audioPlayManager.dispose();
  }


}