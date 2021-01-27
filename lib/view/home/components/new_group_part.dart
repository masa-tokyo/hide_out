import 'package:flutter/material.dart';
import 'package:voice_put/view/common/components/rounded_raised_button.dart';
import 'package:voice_put/view/join_group/join_group_screen.dart';
import 'package:voice_put/view/start_group/start_group_screen.dart';
import 'package:voice_put/utils/style.dart';

class NewGroupPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            "New Group",
            style: homeScreenLabelTextStyle,
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        RoundedRaisedButton(
          label: "Start a New Group",
          onPressed: () => _openStartGroupScreen(context),
        ),
        SizedBox(
          height: 12.0,
        ),
        RoundedRaisedButton(onPressed: () => _openJoinGroupScreen(context), label: "Join a Group"),
      ],
    );
  }

  _openStartGroupScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartGroupScreen(),
      ),
    );
  }

  _openJoinGroupScreen(BuildContext context) {
    Navigator.pushReplacement(
      context, _createRoute(context, JoinGroupScreen())
    );
  }
  Route<Object> _createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
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
