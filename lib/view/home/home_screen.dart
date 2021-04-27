import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/tutorial.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/preparation_note_screen.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';

import 'components/my_group_part.dart';
import 'components/new_group_part.dart';


class HomeScreen extends StatelessWidget {
  final bool isSignedUp;
  HomeScreen({@required this.isSignedUp});


  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);


    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButtonForHome(isSignedUp: isSignedUp),
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

}

//------------------------------------------------------------------------------------------------------FloatingActionButton

// using tutorial requires StatefulWidget
class FloatingActionButtonForHome extends StatefulWidget {
  final bool isSignedUp;

  FloatingActionButtonForHome({@required this.isSignedUp});

  @override
  _FloatingActionButtonForHomeState createState() => _FloatingActionButtonForHomeState();
}

class _FloatingActionButtonForHomeState extends State<FloatingActionButtonForHome> {
  final buttonKey = GlobalKey();

  @override
  void initState() {
    if(widget.isSignedUp){
      _showTutorial();
    }
    super.initState();
  }

  void _showTutorial() {
    List <TutorialItens> _tutorialItems = [];

    _tutorialItems.add(
        TutorialItens(
          globalKey: buttonKey,
          touchScreen: true,
          bottom: 130,
          right: 20,
          shapeFocus: ShapeFocus.oval,
          children: [
            Column(
              children: [
                Text("Make your 1st record now!", style: tutorialTextStyle,),
              ],
            ),
          ],
          widgetNext: Container(),
        )
    );

    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      Tutorial.showTutorial(context, _tutorialItems);
    });

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: buttonKey,
        child: Icon(Icons.keyboard_voice), onPressed: () => _openPreparationNoteScreen(context)
    );
  }

  _openPreparationNoteScreen(BuildContext context) {
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

