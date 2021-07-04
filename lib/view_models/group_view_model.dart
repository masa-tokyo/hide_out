import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/post.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/%20data_models/notification.dart' as d;
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/utils/constants.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final AudioPlayManager audioPlayManager;

  GroupViewModel(
      {this.groupRepository, this.postRepository, this.userRepository, this.audioPlayManager});

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

  List<d.Notification> _notifications = [];
  List<d.Notification> get notifications => _notifications;


  bool _isAudioFinished = false;
  bool get isAudioFinished => _isAudioFinished;

  bool _isAnotherAudioPlaying = false;
  bool get isAnotherAudioPlaying => _isAnotherAudioPlaying;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _autoExitDays = 4;
  int get autoExitDays => _autoExitDays;

  List<bool> _isPlayings = [];
  List<bool> get isPlayings => _isPlayings;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  List<String> _audioUrls = [];
  List<String> get audioUrls => _audioUrls;

  List<int> _plays = [];
  List<int> get plays => _plays;

  final assetsAudioPlayer = AssetsAudioPlayer();


  //---------------------------------------------------------------------------- Audio methods

  void resetPlays() {
    _plays.clear();
  }

  Future<bool> returnIsPlaying(int index) async{
    var result = _isPlayings[index];
    return result;
  }


  Future<void> playAudio(int index) async {

    _plays.add(0);

    //open playlist only for the first time
    if(_plays.length == 1){
      var audios = <Audio>[];
      audioUrls.forEach((element) {
        audios.add(Audio.network(element));
      });
      assetsAudioPlayer.open(
        Playlist(
            audios: audios
        ),
        loopMode: LoopMode.none,
      );
    } else {
      //update the button of previous audio, if any is being played
      _isPlayings[_currentIndex] = false;
      notifyListeners();

    }

    _currentIndex = index;
    assetsAudioPlayer.playlistPlayAtIndex(_currentIndex);

    _isPlayings[_currentIndex] = true;
    notifyListeners();

  }

  Future<void> pauseAudio() async {
    _isPlayings[_currentIndex] = false;

    assetsAudioPlayer.pause();
    notifyListeners();
  }

  Future<void> resumeAudio(String audioUrl) async {
    await audioPlayManager.playAudio(audioUrl);
  }

  onAudioFinished(AudioPlayManager audioPlayManager) {
    _isAudioFinished = audioPlayManager.isAudioFinished;
    notifyListeners();
  }

  Future<void> stopAnotherAudio() async {
    await audioPlayManager.stopAnotherAudio();
  }

  onAnotherPlayerStopped(AudioPlayManager audioPlayManager) {
    _isAnotherAudioPlaying = audioPlayManager.isAnotherAudioPlaying;
    _isPlaying = audioPlayManager.isPlaying;
    notifyListeners();
  }

  Future<void> updateStatus() async {
    await audioPlayManager.updateStatus();
  }

  onStatusUpdated(AudioPlayManager audioPlayManager) {
    _isPlaying = audioPlayManager.isPlaying;
    _isAnotherAudioPlaying = audioPlayManager.isPlaying;
    notifyListeners();
  }


  //---------------------------------------------------------------------------- PostRepository

  Future<void> getGroupPosts(Group group) async {
    await postRepository.getPostsByGroup(group.groupId);

  }

  onGroupPostsObtained(PostRepository postRepository) {
    _isProcessing = postRepository.isProcessing;
    _posts = postRepository.posts;
    _setAudioUrls(_posts);
    //to avoid being called everytime deleteNotification() is called
    if(_plays.length == 0) {
      _setIsPlayings(_posts.length);
      _setListener();
    }
    notifyListeners();
  }
  void _setIsPlayings(int length) {
      for (var i = 0; i < length; i ++){
        _isPlayings.length = length;
        _isPlayings[i] = false;
      }

  }

  void _setAudioUrls(List<Post> posts) {
    posts.forEach((element) {
      _audioUrls.add(element.audioUrl);
    });
  }

  void _setListener() {
    //called everytime the current audio is finished, except for the last one
    assetsAudioPlayer.playlistAudioFinished.listen((event) {

        _isPlayings[_currentIndex] = false;

        //next audio
        _currentIndex = event.index + 1;
        _isPlayings[_currentIndex] = true;

        if(posts[_currentIndex].userId != currentUser.userId){
          deleteNotification(postId: _posts[_currentIndex].postId);
          insertListener(posts[_currentIndex]);
        }

      notifyListeners();
    });

    //called even when the playlist is yet to be complete
    assetsAudioPlayer.playlistFinished.listen((isFinished) {
      if(isFinished){
        _isPlayings[_currentIndex] = false;

        if(posts[_currentIndex].userId != currentUser.userId){
          deleteNotification(postId: _posts[_currentIndex].postId);
          insertListener(posts[_currentIndex]);
        }

        notifyListeners();
      }

    });

  }


  Future<void> deletePost(Post post) async {
    await postRepository.deletePost(post.postId);
    await userRepository.deleteNotification(
        notificationDeleteType: NotificationDeleteType.DELETE_POST,
        postId: post.postId);
  }

  Future<void> insertListener(Post post) async {
    await postRepository.insertListener(post, currentUser);
  }





  //---------------------------------------------------------------------------- GroupRepository
  Future<void> getGroupInfo(String groupId) async {
    await groupRepository.getGroupInfo(groupId);

  }

  onGroupInfoObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _group = groupRepository.group;

    notifyListeners();
  }

  void updateAutoExitPeriod(int intDays) {
    _autoExitDays = intDays;

    notifyListeners();

  }

  Future<void> updateGroupInfo(String groupId) async {
    await groupRepository.updateGroupInfo(
        group.copyWith(groupName: groupName, description: description, autoExitDays: autoExitDays));

    //for opening the screen next time
    _group = await groupRepository.returnGroupInfo(groupId);
    _autoExitDays = _group.autoExitDays;

  }

  onGroupInfoUpdated(GroupRepository groupRepository) {
    _group = groupRepository.group;
    notifyListeners();
  }

  Future<void> leaveGroup(Group group) async {
    await groupRepository.leaveGroup(group, currentUser);
    await userRepository.deleteNotification(
        notificationDeleteType: NotificationDeleteType.LEAVE_GROUP,
        groupId: group.groupId);
  }

  Future<void> getMemberInfo(Group group) async {
    await userRepository.getUsersByGroupId(group);
  }

  onGroupMemberInfoObtained(UserRepository userRepository) {
    _isProcessing = userRepository.isProcessing;
    _groupMembers = userRepository.groupMembers;
    notifyListeners();
  }

  Future<Group> returnGroupInfo(String groupId) async{
    return await groupRepository.returnGroupInfo(groupId);

  }

  Future<void> deleteGroup(Group group) async{
    await groupRepository.deleteGroup(group, currentUser);
    await userRepository.deleteNotification(
        notificationDeleteType: NotificationDeleteType.DELETE_GROUP,
        groupId: group.groupId);

  }

  //---------------------------------------------------------------------------- UserRepository
  Future<void> getNotifications() async{
    await userRepository.getNotifications();
  }

  onNotificationsFetched(UserRepository userRepository) {
    _notifications = userRepository.notifications;
    _isProcessing = userRepository.isProcessing;
    if(_isPlayings.length != 0){
    }

    notifyListeners();
  }

  Future<void> deleteNotification({String postId}) async{
    await userRepository.deleteNotification(
        notificationDeleteType: NotificationDeleteType.OPEN_POST,
        postId: postId);
  }








}
