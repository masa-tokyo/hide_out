import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/repositories/user_repository.dart';
import 'package:hide_out/utils/constants.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository? userRepository;

  LoginViewModel({this.userRepository});

  User? get currentUser  => UserRepository.currentUser;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  LoginScreenStatus _loginScreenStatus = LoginScreenStatus.FAILED;
  LoginScreenStatus get loginScreenStatus => _loginScreenStatus;

  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<bool> isSignIn() async {
    return await userRepository!.isSignIn();
  }

  Future<void> signInOrSignUpWithGoogle() async {
    _isProcessing = true;
    notifyListeners();

    _loginScreenStatus = await userRepository!.signInOrSignUpWithGoogle();

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> signInOrSignUpWithApple() async {
    _isProcessing = true;
    notifyListeners();

    _loginScreenStatus = await userRepository!.signInOrSignUpWithApple();

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> updateProfilePicture() async {

    await userRepository!.updateProfilePicture();
  }

  onUserInfoUpdated(UserRepository userRepository) {
    _imageFile = userRepository.imageFile;
    notifyListeners();
  }

  Future<void> signOut() async {
    await userRepository!.signOut();
  }


  Future<void> deleteAccount() async{
    await userRepository!.deleteAccount();
  }

}