import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/recording/recording_screen.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  GroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_voice),
        onPressed: () => _openRecordingScreen(context),
      ),
      appBar: AppBar(
        title: Text(group.groupName),
        actions: [_groupEditButton()],
        //todo when coming from StartGroupScreen, change back_arrow to close button
      ),
      //todo show post data
      body: Center(child: Text("post data")),
    );
  }

  Widget _groupEditButton() {
    return IconButton(
      icon: Icon(Icons.more_vert),
      //todo show pop up menu
      onPressed: null,
    );
  }

  _openRecordingScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(context));

  }

  Route<Object> _createRoute(BuildContext context) {

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RecordingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child){
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,);

        });
  }

}
