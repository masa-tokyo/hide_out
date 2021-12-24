import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/view/common/items/button_with_icon.dart';
import 'package:hide_out/view/common/items/button_with_image.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';
import 'package:hide_out/view/home/home_screen.dart';
import 'package:hide_out/view/login/user_info_input_screen.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:hide_out/utils/style.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, model, child) {
              return model.isProcessing
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 0.8 * deviceData.size.width,
                        ),
                        SizedBox(
                          height: 200.0,
                        ),
                        ButtonWithImage(
                          onPressed: () =>
                              _signInOrSignUp(context, model, true),
                          color: googleIconButtonColor,
                          isBordered: true,
                          imagePath: "assets/images/google_logo.png",
                          label: Text(
                            "Continue with Google",
                            style: buttonBlackTextStyle,
                          ),
                          height: 26.0,
                          width: 26.0,
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        ButtonWithIcon(
                          onPressed: () =>
                              _signInOrSignUp(context, model, false),
                          isBordered: false,
                          label: Text(
                            "Continue with Apple",
                            style: buttonWhiteTextStyle,
                          ),
                          color: Colors.black,
                          icon: Icon(
                            FontAwesomeIcons.apple,
                            size: 26.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  _signInOrSignUp(
      BuildContext context, LoginViewModel model, bool isGoogle) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    if (isGoogle) {
      await loginViewModel.signInOrSignUpWithGoogle();
    } else {
      if (Platform.isIOS) {
        await loginViewModel.signInOrSignUpWithApple();
      } else {
        showHelpDialog(
            context: context,
            contentString: "For Android users, please sign in/up via Google!",
            okayString: "Okay",
            onConfirmed: null);
      }
    }

    switch (loginViewModel.loginScreenStatus) {
      case LoginScreenStatus.SIGNED_IN:
        _openHomeScreen(context);
        break;

      case LoginScreenStatus.SIGNED_UP:
        _openUserNameInputScreen(context);
        break;

      case LoginScreenStatus.FAILED:
        Fluttertoast.showToast(
          msg: "Sign up failed",
        );
        break;
    }
  }

  _openHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          isSignedUp: false,
        ),
      ),
    );
  }

  _openUserNameInputScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => UserInfoInputScreen(
                  from: ProfileEditScreensOpenMode.SIGN_UP,
                )));
  }
}
