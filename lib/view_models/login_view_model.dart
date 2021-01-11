import 'package:flutter/material.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  LoginViewModel({this.userRepository});

  bool isLoading = false;
  bool isSuccessful = false;

  Future<bool> isSignIn() async{
    return await userRepository.isSignIn();
  }

  Future<void> signUp() async{
    isLoading = true;
    notifyListeners();

    isSuccessful = await userRepository.signUp();

    isLoading = false;
    notifyListeners();
  }

}