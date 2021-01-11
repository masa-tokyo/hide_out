import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/di/providers.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view/login/login_screen.dart';
import 'package:voice_put/view_models/login_view_model.dart';

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

    return MaterialApp(
      title: "VoicePut",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: loginViewModel.isSignIn(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          return (snapshot.hasData && snapshot.data)
              ? HomeScreen()
              : LoginScreen();
        },
      ),

    );
  }
}
