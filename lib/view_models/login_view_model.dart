import 'package:flutter/material.dart';
import 'package:voice_put/models/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  LoginViewModel({this.userRepository});

  bool _isSuccessful = false;
  bool get isSuccessful => _isSuccessful;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Future<bool> isSignIn() async{
    return await userRepository.isSignIn();
  }

  Future<void> signUp() async{
    _isProcessing = true;
    notifyListeners();

    _isSuccessful = await userRepository.signUp();

    _isProcessing = false;
    notifyListeners();

  }



}