import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/confirm_dialog.dart';
import 'package:hide_out/view/login/login_screen.dart';
import 'package:hide_out/view/profile/profile_screen.dart';
import 'package:hide_out/view/recording/recording_screen.dart';
import 'package:hide_out/view_models/home_screen_view_model.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'components/my_group_part.dart';
import 'components/new_group_part.dart';

class HomeScreen extends StatelessWidget {
  final bool isSignedUp;

  HomeScreen({required this.isSignedUp});

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = context.read<HomeScreenViewModel>();

    final deviceData = MediaQuery.of(context);
    final globalKey = GlobalKey();

    return _SetUpHomeScreen(
      globalKey: globalKey,
      isSignedUp: isSignedUp,
      child: Scaffold(
        floatingActionButton: _floatingActionButton(context),
        drawer: _drawer(context),
        appBar: AppBar(
          leading: _settingsButton(context),
          title: Image.asset(
            "assets/images/logo.png",
            width: 0.4 * deviceData.size.width,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await homeScreenViewModel.getMyGroup();
            await homeScreenViewModel.getNotifications();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 26.0,
                ),
                MyGroupPart(
                  globalKey: globalKey,
                ),
                SizedBox(
                  height: 28.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    "New Groups",
                    style: homeScreenLabelTextStyle,
                  ),
                ),
                NewGroupPart(),
                //so that this screen can be scrolled
                SizedBox(
                  height: MediaQuery.of(context).size.height - 240,
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
        child: const FaIcon(FontAwesomeIcons.solidCommentDots),
        onPressed: () {
          Navigator.of(context).push(createRoute(
              context,
              RecordingScreen(
                  from: RecordingButtonOpenMode.POST_FROM_HOME, group: null)));
        });
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
    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(),
          _listTile(
              leading: Icon(Icons.account_circle),
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen()));
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
    );
  }

  Widget _drawerHeader() {
    return Container(
      height: 80.0,
      child: DrawerHeader(
          decoration: BoxDecoration(color: primaryColor),
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
      ),
    );
  }

  _deleteAccount(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();

    //confirm twice
    showConfirmDialog(
      context: context,
      titleString: "Are you sure to delete?",
      contentString: "You will permanently lose all the data",
      onConfirmed: (isConfirmed) async {
        if (isConfirmed) {
          showConfirmDialog(
              context: context,
              titleString: "Final Confirmation",
              contentString: "Delete account?",
              onConfirmed: (isConfirmed) async {
                if (isConfirmed) {
                  await loginViewModel.deleteAccount();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                }
              },
              yesText: Text(
                "Delete",
                style: showConfirmDialogYesTextStyle,
              ),
              noText: Text(
                "Cancel",
              ));
        }
      },
      yesText: Text(
        "Delete",
        style: showConfirmDialogYesTextStyle,
      ),
      noText: Text(
        "Cancel",
      ),
    );
  }
}

//------------------------------------------------------------------------------SetUpHomeScreen

class _SetUpHomeScreen extends StatefulWidget {
  const _SetUpHomeScreen(
      {Key? key,
      required this.child,
      required this.isSignedUp,
      required this.globalKey})
      : super(key: key);

  final Widget child;
  final bool isSignedUp;
  final GlobalKey globalKey;

  @override
  _SetUpHomeScreenState createState() => _SetUpHomeScreenState();
}

class _SetUpHomeScreenState extends State<_SetUpHomeScreen> {
  @override
  void initState() {
    if (widget.isSignedUp) {
      _showTutorial();
    }
    super.initState();
  }

  void _showTutorial() {
    final List<TargetFocus> targets = [];

    targets.add(TargetFocus(
      keyTarget: widget.globalKey,
      contents: [
        TargetContent(
          child: Text(
            "Say hello to the group members!",
            style: tutorialTextStyle,
          ),
        ),
      ],
    ));

    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      TutorialCoachMark(targets: targets).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
