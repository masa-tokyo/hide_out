import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';

class JoinGroupScreen extends StatelessWidget {
  final bool isSignedUp;
  JoinGroupScreen({@required this.isSignedUp});

  @override
  Widget build(BuildContext context) {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    Future(() => joinGroupViewModel.getGroupsExceptForMine());

    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group"),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 32.0,
          ),
          Text(
            "Pick your favorite topics to talk about.",
            style: instructionTextStyle,
          ),
          SizedBox(
            height: 32.0,
          ),
          _groupGridView(context),
          SizedBox(
            height: 24.0,
          ),
          _doneButton(context),
        ],
      )),
    );
  }


  Widget _groupGridView(BuildContext context) {
    var deviceData = MediaQuery.of(context);

    return Container(
      height: 0.6 * deviceData.size.height,
      child: Consumer<JoinGroupViewModel>(
        builder: (context, model, child) {
          return model.isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.count(
                    childAspectRatio: 2.4,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: List.generate(model.groups.length, (int index) {
                      final group = model.groups[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                model.chosenGroups.contains(group)
                                    ? buttonChosenColor
                                    : buttonNotChosenColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: model.chosenGroups.contains(group)
                                    ? Colors.transparent
                                    : notChosenButtonBorderSideColor
                                ),
                              ),
                            ),
                          ),
                          onPressed: () => _onGroupChosen(context, group),
                          child: Text(group.groupName, style: groupNameCardTextStyle,),
                        ),
                      );
                    }),
                  ),
                );
        },
      ),
    );
  }

  _onGroupChosen(BuildContext context, Group group) {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    joinGroupViewModel.chooseGroup(group);
  }

  Widget _doneButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer<JoinGroupViewModel>(
        builder: (context, model, child) {
          return Container(
            width: double.infinity,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  model.chosenGroups.isEmpty ? buttonNotEnabledColor : buttonEnabledColor,
                )),
                onPressed: () => _onDoneButtonPressed(context),
                child: Text(
                  "Done",
                  style: enablingButtonTextStyle,
                ),
            ),
          );
        },
      ),
    );
  }

  _onDoneButtonPressed(BuildContext context) {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    joinGroupViewModel.joinGroup();

    Navigator.pop(context);
    if (isSignedUp){
      Navigator.pushReplacement(context, _createRoute(context, HomeScreen()));
    }

  }

  Route<Object> _createRoute(BuildContext context, Widget screen) {

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
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
