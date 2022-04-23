import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/post_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/utils/constants.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;

  GroupViewModel(
      {required this.groupRepository,
      required this.postRepository,
      required this.userRepository});

  User? get currentUser => UserRepository.currentUser;

  List<Post> _posts = <Post>[];

  List<Post> get posts => _posts;

  Group? _group;

  Group? get group => _group;

  String groupName = "";
  String description = "";

  int? _autoExitDays = 4;

  int? get autoExitDays => _autoExitDays;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  List<d.Notification> _notifications = [];

  List<d.Notification> get notifications => _notifications;

  bool _isAudioFinished = false;

  bool get isAudioFinished => _isAudioFinished;

  bool _isAnotherAudioPlaying = false;

  bool get isAnotherAudioPlaying => _isAnotherAudioPlaying;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  List<bool> _isPlayings = [];

  List<bool> get isPlayings => _isPlayings;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  List<String?> _audioUrls = [];

  List<String?> get audioUrls => _audioUrls;

  List<AssetsAudioPlayer> _players = [];

  List<AssetsAudioPlayer> get players => _players; //exists only one

  List<int> _plays = []; //how many times audios in the playlist are played in total
  List<int> get plays => _plays;

  void updateDescription(String text) {
    description = text;
    notifyListeners();
  }

  void updateGroupName(String text) {
    groupName = text;
    notifyListeners();
  }

  //---------------------------------------------------------------------------- Audio methods

  void resetPlays() {
    _plays.clear();

    _players.clear();
    _players.add(AssetsAudioPlayer());
  }

  Future<bool> returnIsPlaying(int index) async {
    var result = _isPlayings[index];
    return result;
  }

  Future<void> playAudio(int index) async {
    _plays.add(0);

    //open the player only for the 1st time
    if (_plays.length == 1) {
      _openPlayer();
      _addPlayerListener();
    } else {
      //update the button of previous audio, if any is played before
      _isPlayings[_currentIndex] = false;
      notifyListeners();
    }

    var player = _players[0];
    if (_currentIndex == index) {
      //resume audio
      player.play();
    } else {
      _currentIndex = index;
      player.playlistPlayAtIndex(_currentIndex);
    }

    _isPlayings[_currentIndex] = true;
    notifyListeners();
  }

  void _openPlayer() {
    var player = _players[0];

    List<Audio> audios = [];
    _audioUrls.forEach((element) {
      audios.add(Audio.network(element!));
    });

    player.open(
      Playlist(audios: audios),
    );
  }

  void _addPlayerListener() {
    var player = _players[0];

    //check everytime the current audio is finished, except for the last one
    player.playlistAudioFinished.listen((event) {
      _isPlayings[_currentIndex] = false;

      //next audio
      _currentIndex = event.index + 1;
      _isPlayings[_currentIndex] = true;

      if (posts[_currentIndex].userId != currentUser!.userId) {
        deleteNotification(postId: _posts[_currentIndex].postId);
        insertListener(posts[_currentIndex]);
      }

      notifyListeners();
    });

    //check when the playlist finishes
    player.playlistFinished.listen((isFinished) {
      //listen even when the playlist is yet to be complete
      if (isFinished) {
        _isPlayings[_currentIndex] = false;

        if (posts[_currentIndex].userId != currentUser!.userId) {
          deleteNotification(postId: _posts[_currentIndex].postId);
          insertListener(posts[_currentIndex]);
        }
        notifyListeners();
      }
    });
  }

  Future<void> pauseAudio() async {
    if (_isPlayings.length != 0) {
      _isPlayings[_currentIndex] = false;

      var player = _players[0];

      if (_plays.length == 1) {
        player.currentPosition.listen((event) {
          //prevent carrying out the process when event is updated after resuming the audio
          if (!_isPlayings[_currentIndex]) {
            //prevent pausing audio before starting audio
            if (event.inMilliseconds > 0) {
              player.pause();
            }
          }
        });
      }
      notifyListeners();
    }
  }

  //---------------------------------------------------------------------------- PostRepository

  Future<void> getGroupPosts(Group group) async {
    await postRepository.getPostsByGroup(group.groupId);
  }

  onGroupPostsObtained(PostRepository postRepository) {
    //to avoid being called everytime deleteNotification() is called
    if (_plays.length == 0) {
      _posts = postRepository.posts;
      _isProcessing = postRepository.isProcessing;

      //call after posts are retrieved
      if (_posts.length != 0) {
        _addAudioUrls(_posts);
        _addIsPlayings(_posts.length);
      }
    }
    notifyListeners();
  }

  void _addAudioUrls(List<Post> posts) {
    _audioUrls.clear();
    _posts.forEach((element) {
      _audioUrls.add(element.audioUrl);
    });
  }

  void _addIsPlayings(int length) {
    _isPlayings.clear();

    for (var i = 0; i < length; i++) {
      _isPlayings.add(false);
    }
  }

  Future<void> deletePost(Post post) async {
    await postRepository.deletePost(post);
  }

  Future<void> insertListener(Post post) async {
    await postRepository.insertListener(post, currentUser!);
  }

  //---------------------------------------------------------------------------- GroupRepository
  Future<void> getGroupInfo(String? groupId) async {
    await groupRepository.getGroupInfo(groupId);
  }

  onGroupInfoObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _group = groupRepository.group;

    notifyListeners();
  }

  void updateAutoExitPeriod(int? intDays) {
    _autoExitDays = intDays;

    notifyListeners();
  }

  Future<void> updateGroupInfo(String? groupId) async {
    await groupRepository.updateGroupInfo(group!.copyWith(
        groupName: groupName,
        description: description,
        autoExitDays: autoExitDays));
  }

  onGroupInfoUpdated(GroupRepository groupRepository) {
    _group = groupRepository.group;
    //after updating from GroupDetailEditScreen
    if (_group != null) {
      _autoExitDays = _group!.autoExitDays;
      groupName = _group!.groupName;
      description = _group!.description;
    }

    notifyListeners();
  }

  Future<void> leaveGroup(Group group) async {
    await groupRepository.leaveGroup(group, currentUser!);
  }

  Future<Group> returnGroupInfo(String? groupId) async {
    return await groupRepository.returnGroupInfo(groupId);
  }

  Future<void> deleteGroup(Group group) async {
    await groupRepository.deleteGroup(group, currentUser!);
  }

  //---------------------------------------------------------------------------- UserRepository
  Future<void> getNotifications() async {
    await userRepository.getNotifications();
  }

  onNotificationsFetched(UserRepository userRepository) {
    _notifications = userRepository.notifications;
    _isProcessing = userRepository.isProcessing;
    if (_isPlayings.length != 0) {}

    notifyListeners();
  }

  Future<void> deleteNotification({String? postId}) async {
    await userRepository.deleteNotification(
        notificationDeleteType: NotificationDeleteType.OPEN_POST,
        postId: postId);
  }
}
