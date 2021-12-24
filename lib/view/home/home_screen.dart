import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/tutorial.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/confirm_dialog.dart';
import 'package:hide_out/view/common/items/dialog/custom_alert_dialog.dart';
import 'package:hide_out/view/login/login_screen.dart';
import 'package:hide_out/view/profile/profile_screen.dart';
import 'package:hide_out/view/recording/recording_screen.dart';
import 'package:hide_out/view_models/home_screen_view_model.dart';
import 'package:hide_out/view_models/login_view_model.dart';

import 'components/my_group_part.dart';
import 'components/new_group_part.dart';

class HomeScreen extends StatelessWidget {
  final bool isSignedUp;

  HomeScreen({required this.isSignedUp});

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    final deviceData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton:
            FloatingActionButtonForHome(isSignedUp: isSignedUp),
        drawer: _drawer(context),
        appBar: AppBar(
          leading: _settingsButton(context),
          title: Image.asset(
            "assets/images/logo.png",
            width: 0.4 * deviceData.size.width,
          ),
        ),
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              await homeScreenViewModel.getMyGroup();
              await homeScreenViewModel.getNotifications();
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

  Widget _settingsButton(BuildContext passedContext) {
    return Builder(
      builder: (context) {
        return IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer());
      },
    );
  }

  Widget _drawer(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Drawer(
        child: ListView(
          children: [
            _drawerHeader(),
            _listTile(
                leading: Icon(Icons.account_circle),
                title: Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                isCurrentUser: true,
                              )));
                }),
            _listTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              onTap: () => _signOut(context),
            ),
            _listTile(
                title: Text("Delete account"),
                leading: Icon(FontAwesomeIcons.exclamationTriangle),
                onTap: () => _deleteAccount(context))
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return Container(
      height: 120.0,
      child: DrawerHeader(
          decoration: BoxDecoration(color: drawerHeaderColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Settings",
                style: drawerHeaderTextStyle,
              ),
            ],
          )),
    );
  }

  Widget _listTile({
    required Widget title,
    required Widget leading,
    required Function onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: title,
          leading: leading,
          onTap: onTap as void Function(),
        ),
        Divider(),
      ],
    );
  }

  void _signOut(BuildContext context) async {
    final loginViewModel = context.read<LoginViewModel>();

    showConfirmDialog(
      context: context,
      titleString: "Are you sure to log out?",
      contentString: "",
      onConfirmed: (isConfirmed) async {
        if (isConfirmed) {
          Navigator.pop(context);
          await loginViewModel.signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      },
      yesText: Text(
        "Log out",
        style: showConfirmDialogYesTextStyle,
      ),
      noText: Text(
        "Cancel",
        style: showConfirmDialogNoTextStyle,
      ),
    );
  }

  _deleteAccount(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();

    showConfirmDialog(
        context: context,
        titleString: "Are you sure to delete?",
        contentString: "You will permanently lose all the data",
        onConfirmed: (isConfirmed) async{
          if(isConfirmed){
            await loginViewModel.deleteAccount();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          }
        },
        yesText: Text(
          "Delete",
          style: showConfirmDialogYesTextStyle,
        ),
        noText: Text(
          "Cancel",
          style: showConfirmDialogNoTextStyle,
        ),);
  }
}

//------------------------------------------------------------------------------FloatingActionButton

// using tutorial requires StatefulWidget
class FloatingActionButtonForHome extends StatefulWidget {
  final bool isSignedUp;

  FloatingActionButtonForHome({required this.isSignedUp});

  @override
  _FloatingActionButtonForHomeState createState() =>
      _FloatingActionButtonForHomeState();
}

class _FloatingActionButtonForHomeState
    extends State<FloatingActionButtonForHome> {
  final buttonKey = GlobalKey();

  @override
  void initState() {
    if (widget.isSignedUp) {
      _showTutorial();
    }
    super.initState();
  }

  void _showTutorial() {
    List<TutorialItens> _tutorialItems = [];

    _tutorialItems.add(TutorialItens(
      globalKey: buttonKey,
      touchScreen: true,
      bottom: 130,
      right: 20,
      shapeFocus: ShapeFocus.oval,
      children: [
        Column(
          children: [
            Text(
              "You can record from here!",
              style: tutorialTextStyle,
            ),
          ],
        ),
      ],
      widgetNext: Container(),
    ));

    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      Tutorial.showTutorial(context, _tutorialItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: buttonKey,
        child: Icon(Icons.keyboard_voice),
        onPressed: () => _openRecordingScreen(context));
  }

  _openRecordingScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(
        context,
        RecordingScreen(
            from: RecordingButtonOpenMode.POST_FROM_HOME, group: null)));
  }

  Route<Object> _createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}
