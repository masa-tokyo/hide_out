
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:voice_put/models/database_manager.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
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
];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<DatabaseManager, UserRepository>(
    update: (context, dbManager, repository) => UserRepository(dbManager: dbManager),
  ),
  ProxyProvider<DatabaseManager, GroupRepository>(
    update: (context, dbManager, repository) => GroupRepository(dbManager: dbManager),
  ),
];
List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<LoginViewModel>(
    create: (context) => LoginViewModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<StartGroupViewModel>(
      create: (context) => StartGroupViewModel(
            userRepository: Provider.of<UserRepository>(context, listen: false),
            groupRepository: Provider.of<GroupRepository>(context, listen: false),
          )),
  ChangeNotifierProvider<HomeScreenViewModel>(
      create: (context) => HomeScreenViewModel(
        userRepository: Provider.of<UserRepository>(context, listen: false),
        groupRepository: Provider.of<GroupRepository>(context, listen: false),
      )),
  ChangeNotifierProvider<JoinGroupViewModel>(
      create: (context) => JoinGroupViewModel(
        userRepository: Provider.of<UserRepository>(context, listen: false),
        groupRepository: Provider.of<GroupRepository>(context, listen: false),
      )),
  ChangeNotifierProvider<RecordingViewModel>(
      create: (context) => RecordingViewModel(
        userRepository: Provider.of<UserRepository>(context, listen: false),
        groupRepository: Provider.of<GroupRepository>(context, listen: false),
      )),

];
