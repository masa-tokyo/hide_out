import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';
import 'package:hide_out/view/home/home_screen.dart';
import 'package:hide_out/view/login/before_login_screen.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return SetUp(
      child: FutureBuilder(
        future: loginViewModel.isSignIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            return HomeScreen(isSignedUp: false);
          } else if (snapshot.hasData && !snapshot.data!) {
            return BeforeLoginScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}

class SetUp extends StatefulWidget {
  const SetUp({required this.child});

  final Widget child;

  @override
  _SetUpState createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  bool isProcessing = true;
  bool shouldUpdate = false;

  @override
  void initState() {
    _setUp().then((value) => setState(() => isProcessing = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isProcessing || shouldUpdate) {
      return SplashScreen();
    }
    return widget.child;
  }

  Future<void> _setUp() async {
    await Future.wait([
      _checkBuildNumber(),
    ]);
  }

  Future<void> _checkBuildNumber() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: const Duration(seconds: 1)));
    await remoteConfig.fetchAndActivate();
    final requiredBuildNumber = remoteConfig.getInt('required_build_number');
    final info = await PackageInfo.fromPlatform();
    final currentBuildNumber = int.parse(info.buildNumber);

    if (requiredBuildNumber > currentBuildNumber) {
      setState(() {
        shouldUpdate = true;
      });
      await showHelpDialog(
          context: context,
          contentString:
              'The latest version is available now. \nPlease update.',
          okayString: 'Update',
          onConfirmed: () async {
            if (Platform.isIOS) {
              await launch('https://apps.apple.com/app/id1632561765');
            } else {
              await launch(
                  'https://play.google.com/store/apps/details?id=com.masakisato.hideout');
            }
          });
    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          width: 0.8 * MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
