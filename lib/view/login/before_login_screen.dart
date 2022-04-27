import 'package:flutter/material.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/login/login_screen.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class BeforeLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        slides: _createSlides(),
        renderSkipBtn: const SizedBox.shrink(),

        //next button
        renderNextBtn: _nextButton(),

        //done button
        renderDoneBtn: _doneButton(),
        onDonePress: () => _onDonePressed(context),
      ),
    );
  }

  List<Slide> _createSlides() {
    List<Slide> slides = [];

    slides
      ..add(Slide(
          pathImage: "assets/images/icon.png",
          backgroundColor: darkThemeBackgroundColor,
          title: "Welcome to HideOut",
          description:
              " HideOut is a place where you can share audio with people in the same group.",
          styleDescription: slideDescriptionTextStyle))
      ..add(Slide(
          pathImage: "assets/images/slides/group.png",
          backgroundColor: Colors.orange[300],
          title: "Output what you learn",
          description:
              "You can talk about interesting or learnable things that happened in your daily lives.",
          styleDescription: slideDescriptionTextStyle))
      ..add(Slide(
          pathImage: "assets/images/slides/deadline.png",
          backgroundColor: Colors.deepOrangeAccent[100],
          title: "Work together",
          description: "All the members have the same goal: Auto-Exit Period. "
              "Let's record audio before the deadline!",
          styleDescription: slideDescriptionTextStyle));

    return slides;
  }

  Widget _nextButton() {
    return const Icon(
      Icons.arrow_forward,
      size: 26.0,
      color: Colors.white,
    );
  }

  Widget _doneButton() {
    return const Text("START", style: slideDoneButtonTextStyle);
  }

  _onDonePressed(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
