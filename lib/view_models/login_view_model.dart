import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/utils/constants.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository? userRepository;

  LoginViewModel({this.userRepository});

  User? get currentUser  => UserRepository.currentUser;


  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  LoginScreenStatus _loginScreenStatus = LoginScreenStatus.FAILED;
  LoginScreenStatus get loginScreenStatus => _loginScreenStatus;

  Future<bool> isSignIn() async{
    return await userRepository!.isSignIn();
  }

  Future<void> signInOrSignUp() async{
    _isProcessing = true;
    notifyListeners();

    _loginScreenStatus = await userRepository!.signInOrSignUp();

    _isProcessing = false;
    notifyListeners();

  }




}