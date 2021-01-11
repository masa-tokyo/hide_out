import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/group_repository.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final GroupRepository groupRepository;
  final UserRepository userRepository;

  HomeScreenViewModel({this.groupRepository, this.userRepository});

  User get currentUser => UserRepository.currentUser;

  bool isLoading = false;

  List<Group> groups;

  Future<void> getMyGroup() async{
    isLoading = true;
    notifyListeners();

    groups = await groupRepository.getGroupsByUserId(currentUser);

    isLoading = false;
    notifyListeners();

  }

}