import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/di/providers.dart';
import 'package:voice_put/models/repositories/user_repository.dart';
import 'package:voice_put/utils/functions.dart';
import 'package:voice_put/view/home/home_screen.dart';
import 'package:voice_put/view/login/before_login_screen.dart';
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
      onTap: () => unFocusKeyboard(context: context),
      child: MaterialApp(
        title: "HideOut",
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
              backgroundColor: MaterialStateProperty.all<Color?>(elevatedButtonBackgroundColor),
              foregroundColor: MaterialStateProperty.all<Color>(elevatedButtonForegroundColor),
            )
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(textButtonForeGroundColor)
            )
          )
        ),
        home:
        FutureBuilder(
          future: loginViewModel.isSignIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data!){
              return SetUp(child: HomeScreen(isSignedUp: false));

            } else if (snapshot.hasData && !snapshot.data!){
              return BeforeLoginScreen();
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


}

class SetUp extends StatefulWidget {
  const SetUp({required this.child});
  final Widget child;

  @override
  _SetUpState createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {

  @override
  void initState() {
    _setUp();
    super.initState();
  }

  Future<void> _setUp() async {
    final userRepository = context.read<UserRepository>();
    await userRepository.createImageFile();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
