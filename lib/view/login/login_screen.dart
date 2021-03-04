import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view/common/components/button_with_image.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view_models/login_view_model.dart';

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
                      onPressed: () => _signUp(context),
                      color: Color(0xFF4285F4),
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

  _signUp(BuildContext context) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    await loginViewModel.signUp(); //todo[check] should divide sign up and sign in??


    if (!loginViewModel.isSuccessful) {
      Fluttertoast.showToast(msg: "Sign up failed");
    } else {

      _openHomeScreen(context);
    }
  }

  _openHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }
}
