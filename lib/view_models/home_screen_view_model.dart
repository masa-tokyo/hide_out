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

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Group> _groups = List();
  List<Group> get groups => _groups;

  Future<void> getMyGroup() async{

    await groupRepository.getGroupsByUserId(currentUser);


  }

  onMyGroupObtained(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _groups = groupRepository.myGroups;
    notifyListeners();
  }


  Future<bool> checkMyGroup() async{
    return await groupRepository.checkMyGroup(currentUser);
  }

}