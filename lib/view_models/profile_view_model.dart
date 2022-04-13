import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository? userRepository;

  ProfileViewModel({this.userRepository});

  User? get currentUser => UserRepository.currentUser;

  User? _member;
  User? get member => _member;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<void> updateUserName(String userName) async {
    await userRepository!.updateUserInfo(
        updatedCurrentUser: currentUser!.copyWith(inAppUserName: userName),
        isNameUpdated: true);
  }

  onUserInfoUpdated(UserRepository userRepository) {
    _imageFile = userRepository.imageFile;
    notifyListeners();
  }

  Future<void> updateProfilePicture() async {
    await userRepository!.updateProfilePicture();
  }

  Future<void> fetchMember(String memberId) async {
    await userRepository!.fetchUser(memberId);
  }

  onMemberFetched(UserRepository userRepository) {
    _isProcessing = userRepository.isProcessing;
    _member = userRepository.member;

    notifyListeners();
  }

  Future<void> createImageFile() async{
    if (_imageFile == null) {
      // set from remote if the photo in the local device is deleted
      await userRepository!.createImageFile();
    }
  }
}
