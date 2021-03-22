import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/di/providers.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view/login/login_screen.dart';
import 'package:voice_put/view_models/login_view_model.dart';
import 'package:voice_put/utils/style.dart';

void main() async{

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
      onTap: () => _unFocusKeyboard(context),
      child: MaterialApp(
        title: "VoicePut",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: accentColor,
            scaffoldBackgroundColor: backgroundThemeColor,
            appBarTheme: AppBarTheme(
                color: backgroundThemeColor
            ),
            primaryIconTheme: IconThemeData.fallback().copyWith(
                color: primaryIconColor
            ),
            primaryTextTheme: const TextTheme().copyWith(
              headline6: TextStyle().copyWith(
                  color: primaryTextColor
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              fillColor: textFieldFillColor,
            ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(elevatedButtonBackgroundColor),
              foregroundColor: MaterialStateProperty.all<Color>(elevatedButtonForegroundColor),
            )
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(textButtonForeGroundColor)
            )
          )
        ),
        home: FutureBuilder(
          future: loginViewModel.isSignIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data){
              return HomeScreen();
            } else if (snapshot.hasData && !snapshot.data){
              return LoginScreen();
            } else {
              return Scaffold(
                body: Center(child
                    : CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  _unFocusKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}