import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/group/group_screen.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';

import '../../utils/style.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join This Group?"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 36.0,
          ),
          Text(
            group.groupName,
            style: groupDetailNameTextStyle,
          ),
          SizedBox(
            height: 36.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "About",
                  style: groupDetailDescriptionTextStyle,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        group.description,
                        style: groupDetailDescriptionTextStyle,
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          _joinButton(context)
        ],
      ),
    );
  }

  Widget _joinButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 260.0), //todo [check] how about other devices?
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () => _openGroupScreen(context, group),
        child: Text("Join"),
      ),
    );
  }

  _openGroupScreen(BuildContext context, Group group) async {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    await joinGroupViewModel.joinGroup(group);

    Navigator.pushReplacement(
      context,
      _createRoute(context, group),
    );
    //todo show alert dialog?
  }

  Route<Object> _createRoute(BuildContext context, Group group) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GroupScreen(group: group),
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
