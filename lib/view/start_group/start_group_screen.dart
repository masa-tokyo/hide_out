import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view/group/group_screen.dart';
import 'package:voice_put/view/start_group/components/about_group_part.dart';
import 'package:voice_put/view/start_group/components/group_name_part.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

class StartGroupScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start a New Group"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupNamePart(),
            AboutGroupPart(),
            SizedBox(
              height: 12.0,
            ),
            _doneButton(context),
          ],
        ),
      ),
    );
  }

  Widget _doneButton(BuildContext context) {
    return Consumer<StartGroupViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: (model.groupName != "" && model.description != "")
                  ? () => _registerGroup(context)
                  : null,
              color: model.groupName != "" && model.description != ""
              ? Colors.lightBlue : Colors.grey,
              child: Text("Done",
                  style: (model.groupName != "" && model.description != "")
                      ? buttonEnabledTextStyle
                      : buttonNotEnabledTextStyle),
            ),
          ),
        );
      },
    );
  }

  _registerGroup(BuildContext context) async {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    await startGroupViewModel.registerGroup();

    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Done!",
        gravity: ToastGravity.CENTER);


  }

  Route<Object> _createRoute(BuildContext context) {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GroupScreen(group: startGroupViewModel.group),
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
