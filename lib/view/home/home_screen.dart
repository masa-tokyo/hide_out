import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
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
            onRefresh: () async{
              await homeScreenViewModel.getMyGroup();
            },
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
                SizedBox(
                  height: 28.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.keyboard_voice), onPressed: () => _openAudioJournalScreen(context));
  }

  _openAudioJournalScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(
      context,
      PreparationNoteScreen(
        from: RecordingOpenMode.FROM_HOME,
        group: null,
      ),
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
