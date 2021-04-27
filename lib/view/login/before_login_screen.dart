import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:voice_put/utils/style.dart';

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
          description: "Welcome to VoicePut! You can output what you learn with audio recordings.",
          styleDescription: slideDescriptionStyle
      ))
      ..add(Slide(
          pathImage: "assets/images/slides/group.png",
          backgroundColor: Colors.yellowAccent[300],
          title: "Closed Community",
          description:"You can share audio within groups you belong to, which consist of up to 5 members.",
          styleDescription: slideDescriptionStyle
      ))
      ..add(Slide(
          pathImage: "assets/images/slides/deadline.png",
          backgroundColor: Colors.orange[300],
          title: "Auto-Exit System",
          description: "Each member needs to share audio every certain amount of time, which makes their bonds stronger.",
          styleDescription: slideDescriptionStyle

      ));

    return slides;
  }

  Widget _nextButton() {
    return Icon(
      Icons.arrow_forward ,
      size: 26.0,
      color: Colors.white,
    );
  }


 Widget _doneButton() {
    return Text("Start", style: slideDoneButtonTextStyle);
 }


  _onDonePressed(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));

  }




}

