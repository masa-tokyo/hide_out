import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:hide_out/utils/style.dart';

import 'login_screen.dart';

class BeforeLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        slides: _createSlides(),
        renderSkipBtn: Container(),

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
          pathImage: "assets/images/slides/mic.png",
          backgroundColor: Colors.cyan[300],
          title: "Accelerate Learning",
          description:
              "Welcome to HideOut!"
                  " You can output what you learn in everyday life with audio recordings.",
          styleDescription: slideDescriptionTextStyle))
      ..add(Slide(
          pathImage: "assets/images/slides/group.png",
          backgroundColor: Colors.yellowAccent[300],
          title: "Closed Community",
          description:
              "You can share audio within groups you belong to, which consist of up to 5 members.",
          styleDescription: slideDescriptionTextStyle))
      ..add(Slide(
          pathImage: "assets/images/slides/deadline.png",
          backgroundColor: Colors.orange[300],
          title: "Auto-Exit System",
          description:
              "Each member needs to share audio in every certain period, which makes their bonds stronger.",
          styleDescription: slideDescriptionTextStyle));

    return slides;
  }

  Widget _nextButton() {
    return Icon(
      Icons.arrow_forward,
      size: 26.0,
      color: Colors.white,
    );
  }

  Widget _doneButton() {
    return Text("START", style: slideDoneButtonTextStyle);
  }

  _onDonePressed(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
