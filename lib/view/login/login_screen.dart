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
        body: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, model, child){
              return model.isLoading
              ? CircularProgressIndicator()
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWithImage(
                      onPressed: () => _signUp(context),
                      color: Colors.white30,
                      imagePath: "assets/images/google.png",
                      label: "Sign Up With Google")
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
