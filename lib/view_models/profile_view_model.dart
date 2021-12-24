import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository? userRepository;

  ProfileViewModel({this.userRepository});

  User? get currentUser => UserRepository.currentUser;

  File? _imageFile;
  File? get imageFile => _imageFile;


  Future<void> updateUserName(String userName) async {
    await userRepository!.updateUserInfo(currentUser!.copyWith(inAppUserName: userName));
  }

  onUserInfoUpdated(UserRepository userRepository) {
    _imageFile = userRepository.imageFile;
    notifyListeners();
  }

  Future<void> updateProfilePicture() async{
    await userRepository!.updateProfilePicture();

  }







}