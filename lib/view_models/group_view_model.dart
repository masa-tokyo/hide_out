import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/post_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/models/tracking.dart';
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

  List<bool> _isPlayings = [];

  int _currentIndex = 0;

  List<String?> _audioUrls = [];

  List<AssetsAudioPlayer> _players = [];

  List<AssetsAudioPlayer> get players => _players; //exists only one

  AssetsAudioPlayer _player = AssetsAudioPlayer();

  //how many times audios in the playlist are played in total
  List<int> _plays = [];

  void updateDescription(String text) {
    description = text;
    notifyListeners();
  }

  void updateGroupName(String text) {
    groupName = text;
    notifyListeners();
  }

  //---------------------------------------------------------------------------- Audio methods

  // reset properties that are not connected to repositories and not reset automatically
  void resetPlayer() {
    _player = AssetsAudioPlayer();
    _currentIndex = 0;

    _plays.clear();
    _isPlayings.clear();
    _audioUrls.clear();
  }

  Future<bool> returnIsPlaying(int index) async {
    var result = _isPlayings[index];
    return result;
  }

  Future<void> playAudio(int index, AudioPlayType playType) async {
    _plays.add(0);

    if (_plays.length > 1) {
      //update the button of previous audio, if any is played before
      _isPlayings[_currentIndex] = false;
      notifyListeners();
    }

    if (_currentIndex == index) {
      //resume audio
      _player.play();
    } else {
      _currentIndex = index;
      _player.playlistPlayAtIndex(_currentIndex);
    }

    _isPlayings[_currentIndex] = true;

    // for analysis
    assert(playType == AudioPlayType.POST_MINE ||
        playType == AudioPlayType.POST_OTHERS);
    Tracking().logEvent(EventType.PLAY_TALK, eventParams: {
      'play_type': playType == AudioPlayType.POST_MINE ? 'mine' : 'others',
    });

    notifyListeners();
  }

  Future<void> _openPlayer() async {
    List<Audio> audios = [];
    _audioUrls.forEach((element) {
      audios.add(Audio.network(element!));
    });

    await _player.open(
      Playlist(audios: audios),
      // Since the player should start playing right after opening the screen,
      // turn off the autoStart property
      autoStart: false,
    );
  }

  void _addPlayerListener() {
    //check everytime the current audio is finished, except for the last one
    _player.playlistAudioFinished.listen((event) {
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
    _player.playlistFinished.listen((isFinished) {
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

      if (_plays.length == 1) {
        _player.currentPosition.listen((event) {
          //prevent carrying out the process when event is updated after resuming the audio
          if (!_isPlayings[_currentIndex]) {
            //prevent pausing audio before starting audio
            if (event.inMilliseconds > 0) {
              _player.pause();
            }
          }
        });
      }
      notifyListeners();
    }
  }

  //---------------------------------------------------------------------------- PostRepository

  Future<void> getGroupPosts(Group group) async {
    await postRepository.getPostsByGroup(group.groupId, currentUser!.userId);
  }

  onGroupPostsObtained(PostRepository postRepository) async {
    //to avoid being called everytime deleteNotification() is called
    if (_plays.length == 0) {
      _posts = postRepository.posts;
      _isProcessing = postRepository.isProcessing;

      //call after posts are retrieved
      if (_posts.length != 0) {
        _addAudioUrls(_posts);
        _addIsPlayings(_posts.length);
        await _openPlayer();
        _addPlayerListener();
      }
    }
    notifyListeners();
  }

  void _addAudioUrls(List<Post> posts) {
    _posts.forEach((element) {
      _audioUrls.add(element.audioUrl);
    });
  }

  void _addIsPlayings(int length) {
    for (var i = 0; i < length; i++) {
      _isPlayings.add(false);
    }
  }

  Future<void> deletePost(Post post) async {
    await postRepository.deletePost(post);
  }

  Future<void> removePost(Post post) async {
    await postRepository.removePost(post, currentUserId: currentUser!.userId);
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
