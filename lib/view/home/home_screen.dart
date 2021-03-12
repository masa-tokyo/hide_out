import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/audio_journal_screen.dart';
import 'package:voice_put/view/recording/preparation_note_screen.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';

import 'components/my_group_part.dart';
import 'components/new_group_part.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: _floatingActionButton(context),
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () => homeScreenViewModel.getMyGroup(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 26.0,
                ),
                MyGroupPart(),
                SizedBox(
                  height: 28.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    "New Group",
                    style: homeScreenLabelTextStyle,
                  ),
                ),
                NewGroupPart(),
                SizedBox(height: 28.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.keyboard_voice),
        onPressed: () => _openAudioJournalScreen(context));
  }

  _openAudioJournalScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(
        context,
        //1st screen
        AudioJournalScreen(
          titleString: "Preparation 1/3",
          questionString1: "What did you do today?",
          questionString2: "",
          questionString3: "",
          icon: Icon(Icons.close),

          //2nd screen
          screen: AudioJournalScreen(
            icon: Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
            titleString: "Preparation 2/3",
            questionString1: "Anything impressive?",
            questionString2: "&",
            questionString3: "why?",

            //3rd screen
            screen: PreparationNoteScreen()
          ),
        )
        //1st screen
        ));
  }

  Route<Object> _createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}
