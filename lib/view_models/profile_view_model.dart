import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/member.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/group_repository.dart';
import 'package:hide_out/models/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  ProfileViewModel(
      {required this.userRepository, required this.groupRepository});

  User? get currentUser => UserRepository.currentUser;

  Member? _member;
  Member? get member => _member;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> updateUserName(String userName) async {
    await userRepository.updateUserInfo(
        updatedCurrentUser: currentUser!.copyWith(inAppUserName: userName),
        isNameUpdated: true);
  }

  onUserInfoUpdated(UserRepository userRepository) {
    _isLoading = userRepository.isLoading;
    notifyListeners();
  }

  Future<void> updateProfilePicture() async {
    await userRepository.updateProfilePicture();

  }

  Future<void> fetchMember(String groupId, String memberId) async {
    await groupRepository.fetchMember(groupId, memberId);
  }

  onMemberFetched(GroupRepository groupRepository) {
    _isProcessing = groupRepository.isProcessing;
    _member = groupRepository.member;

    notifyListeners();
  }

}
