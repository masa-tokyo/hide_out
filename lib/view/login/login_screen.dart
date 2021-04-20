import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/view/common/items/button_with_image.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view/login/user_name_input_screen.dart';
import 'package:voice_put/view_models/login_view_model.dart';
import 'package:voice_put/utils/style.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, model, child){
              return model.isProcessing
              ? CircularProgressIndicator()
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWithImage(
                      onPressed: () => _signInOrSignUp(context),
                      color: googleIconButtonColor,
                      imagePath: "assets/images/btn_google_dark_normal_ios.png",
                      label: "Sign up with Google")
                ],
              );
            },

          ),
        ),
      ),
    );
  }

  _signInOrSignUp(BuildContext context) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    await loginViewModel.signInOrSignUp();

    switch(loginViewModel.loginScreenStatus) {
      case LoginScreenStatus.SIGNED_IN:
        _openHomeScreen(context);
        break;

      case LoginScreenStatus.SIGNED_UP:
        _openUserNameInputScreen(context);
        break;

      case LoginScreenStatus.FAILED:
        Fluttertoast.showToast(msg: "Sign up failed");
        break;
    }

  }

  _openHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  _openUserNameInputScreen(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> UserNameInputScreen()));
  }
}
