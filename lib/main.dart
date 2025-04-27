import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/di/providers.dart';
import 'package:hide_out/models/tracking.dart';
import 'package:hide_out/view/root_screen.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/login/terms_and_conditions.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';

import 'view/login/privacy_policy_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  // remove '#' from url
  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: globalProviders,
      child: MyApp(),
    ),
  );

}



Future<void> _initializeFirebase() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => unFocusKeyboard(context: context),
      child: MaterialApp(
        title: "HideOut",
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        navigatorObservers: [
          Tracking().getPageViewObserver(),
        ],
        initialRoute: RootScreen.routeName,
        routes: {
          RootScreen.routeName: (_) => RootScreen(),
          PrivacyPolicyScreen.routeName: (_) => PrivacyPolicyScreen(),
          TermsAndConditionsScreen.routeName: (_) => TermsAndConditionsScreen(),
        },
      ),
    );
  }
}

