import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  ProfileViewModel({this.userRepository});

  User get currentUser => UserRepository.currentUser;



  Future<void> updateUserName(String userName) async{
    await userRepository.updateUserInfo(currentUser.copyWith(inAppUserName: userName));
  }

  onUserInfoUpdated(UserRepository userRepository) {
    notifyListeners();
  }






}