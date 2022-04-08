import 'package:hide_out/models/database_manager.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/post_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/view_models/group_view_model.dart';
import 'package:hide_out/view_models/home_screen_view_model.dart';
import 'package:hide_out/view_models/join_group_view_model.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:hide_out/view_models/profile_view_model.dart';
import 'package:hide_out/view_models/recording_view_model.dart';
import 'package:hide_out/view_models/start_group_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  Provider<DatabaseManager>(create: (_) => DatabaseManager()),
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
  ChangeNotifierProxyProvider<UserRepository, LoginViewModel>(
      create: (context) => LoginViewModel(
            userRepository: Provider.of<UserRepository>(context, listen: false),
          ),
      update: (context, userRepository, viewModel) =>
          viewModel!..onUserInfoUpdated(userRepository)),
  ChangeNotifierProxyProvider<UserRepository, ProfileViewModel>(
    create: (context) => ProfileViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
    ),
    update: (context, userRepository, viewModel) => viewModel!
      ..onUserInfoUpdated(userRepository)
      ..onMemberFetched(userRepository),
  ),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository,
      StartGroupViewModel>(
    create: (context) => StartGroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) =>
        viewModel!..onGroupRegistered(groupRepository),
  ),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository,
      HomeScreenViewModel>(
    create: (context) => HomeScreenViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) => viewModel!
      ..onMyGroupObtained(groupRepository)
      ..onNotificationsFetched(userRepository),
  ),
  ChangeNotifierProxyProvider2<UserRepository, GroupRepository,
      JoinGroupViewModel>(
    create: (context) => JoinGroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
    ),
    update: (context, userRepository, groupRepository, viewModel) => viewModel!
      ..onGroupsExceptForMineObtained(groupRepository)
      ..onGroupMemberInfoObtained(userRepository),
  ),
  ChangeNotifierProxyProvider3<UserRepository, GroupRepository, PostRepository,
      RecordingViewModel>(
    create: (context) => RecordingViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
      postRepository: Provider.of<PostRepository>(context, listen: false),
    ),
    update:
        (context, userRepository, groupRepository, postRepository, viewModel) =>
            viewModel!
              ..onRecordingPosted(postRepository)
              ..onMyGroupObtained(groupRepository)
              ..onSelfIntroUploaded(userRepository),
  ),
  ChangeNotifierProxyProvider3<UserRepository, GroupRepository, PostRepository,
      GroupViewModel>(
    create: (context) => GroupViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
      groupRepository: Provider.of<GroupRepository>(context, listen: false),
      postRepository: Provider.of<PostRepository>(context, listen: false),
    ),
    update:
        (context, userRepository, groupRepository, postRepository, viewModel) =>
            viewModel!
              ..onGroupPostsObtained(postRepository)
              ..onGroupInfoObtained(groupRepository)
              ..onGroupMemberInfoObtained(userRepository)
              ..onGroupInfoUpdated(groupRepository)
              ..onNotificationsFetched(userRepository),
  ),
];
