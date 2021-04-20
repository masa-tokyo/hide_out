import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:voice_put/models/audio_play_manager.dart';
import 'package:voice_put/models/database_manager.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/post_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/view_models/group_view_model.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';
import 'package:voice_put/view_models/login_view_model.dart';
import 'package:voice_put/view_models/recording_view_model.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  Provider<DatabaseManager>(create: (_) => DatabaseManager()),
  ChangeNotifierProvider<AudioPlayManager>(create: (_) => AudioPlayManager()),
];

List<SingleChildWidget> dependentModels = [
  ChangeNotifierProvider<UserRepository>(
    create: (context) => UserRepository(
      dbManager: Provider.of<DatabaseManager>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<GroupRepository>(
    create: (context) => GroupRepository(
      dbManager: Provider.of<DatabaseManager>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<PostRepository>(
    create: (context) => PostRepository(
      dbManager: Provider.of<DatabaseManager>(context, listen: false),
    ),
  ),
];


List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<LoginViewModel>(
      create: (context) => LoginViewModel(
        userRepository: Provider.of<UserRepository>(context, listen: false),
      )),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository, StartGroupViewModel>(
    create: (context) => StartGroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) => viewModel,
  ),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository, HomeScreenViewModel>(
    create: (context) => HomeScreenViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) =>
        viewModel..onMyGroupObtained(groupRepository),
  ),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository, JoinGroupViewModel>(
    create: (context) => JoinGroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) => viewModel
      ..onGroupsExceptForMineObtained(groupRepository)
      ..onGroupMemberInfoObtained(userRepository),
  ),
  ChangeNotifierProxyProvider2<GroupRepository, PostRepository, RecordingViewModel>(
    create: (context) => RecordingViewModel(
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
      postRepository: Provider.of<PostRepository>(context, listen: false),
    ),
    update: (context, groupRepository, postRepository, viewModel) => viewModel
      ..onRecordingPosted(postRepository)
      ..onMyGroupObtained(groupRepository),
  ),
  ChangeNotifierProxyProvider4<UserRepository, GroupRepository, PostRepository, AudioPlayManager, GroupViewModel>(
    create: (context) => GroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
      postRepository: Provider.of<PostRepository>(context, listen: false),
      audioPlayManager: Provider.of<AudioPlayManager>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, postRepository, audioPlayManager, viewModel) => viewModel
      ..onGroupPostsObtained(postRepository)
      ..onAudioFinished(audioPlayManager)
      ..onAnotherPlayerStopped(audioPlayManager)
      ..onStatusUpdated(audioPlayManager)
      ..onGroupInfoObtained(groupRepository)
      ..onGroupMemberInfoObtained(userRepository)
      ..onGroupInfoUpdated(groupRepository),
),
];
