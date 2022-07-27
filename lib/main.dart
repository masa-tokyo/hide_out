import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/di/providers.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';
import 'package:hide_out/view/home/home_screen.dart';
import 'package:hide_out/view/login/before_login_screen.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:hide_out/view_models/profile_view_model.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: globalProviders,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () => unFocusKeyboard(context: context),
      child: MaterialApp(
        title: "HideOut",
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: FutureBuilder(
          future: loginViewModel.isSignIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return SetUp(child: HomeScreen(isSignedUp: false));
            } else if (snapshot.hasData && !snapshot.data!) {
              return BeforeLoginScreen();
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
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
    Future.wait([
      context.read<ProfileViewModel>().createImageFile(),
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
          contentString: 'The latest version is available now. Please update.',
          okayString: 'Update',
          onConfirmed: () async {
            //todo add urls
            if (Platform.isIOS) {
              await launch('');
            } else {
              await launch('');
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
