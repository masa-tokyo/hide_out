import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view/recording/audio_journal_screen.dart';
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
              children: [
                SizedBox(
                  height: 26.0,
                ),
                MyGroupPart(),
                SizedBox(
                  height: 28.0,
                ),
                NewGroupPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _floatingActionButton(BuildContext context) {
   final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
   return homeScreenViewModel.groups.length == 0
   //todo when coming back from JoinGroup without joining, floating action button appears
       ? Container()
       : FloatingActionButton(
       child: Icon(Icons.keyboard_voice),
       onPressed: () => _openAudioJournalScreen(context));
 }


  _openAudioJournalScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(context, AudioJournalScreen()));
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
