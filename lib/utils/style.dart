import 'package:flutter/material.dart';

final theme = ThemeData.from(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: customSwatch,
  ),
);

//Theme Data
final lightTheme = theme.copyWith(
  textTheme: ThemeData.light().textTheme.apply(bodyColor: lightThemeTextColor),
  scaffoldBackgroundColor: lightThemeBackgroundColor,
  // for Scaffold.body
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: lightThemeBackgroundColor,
    centerTitle: true,
    titleTextStyle: lightThemeAppBarTitleTextStyle,
    iconTheme: IconThemeData(
      color: lightThemeTextColor,
    ),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: customSwatch),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      //text color of alert dialog buttons
      foregroundColor: MaterialStateProperty.all<Color>(lightThemeTextColor),
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // default color for texts
  textTheme: ThemeData.dark().textTheme.apply(bodyColor: darkThemeTextColor),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: darkThemeBackgroundColor,
    titleTextStyle: darkThemeAppBarTitleTextStyle,
    centerTitle: true,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: customSwatch, foregroundColor: Colors.white),
  textSelectionTheme: TextSelectionThemeData(cursorColor: customSwatch[50]),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color?>(customSwatch),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  )),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      //text color of alert dialog buttons
      foregroundColor: MaterialStateProperty.all<Color>(darkThemeTextColor),
    ),
  ),
);

const MaterialColor customSwatch = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFece8e7),
    100: Color(0xFFcfc6c3),
    200: Color(0xFFafa09b),
    300: Color(0xFF8e7973),
    400: Color(0xFF765d55),
    500: Color(_primaryColorValue),
    600: Color(0xFF563a31),
    700: Color(0xFF4c322a),
    800: Color(0xFF422a23),
    900: Color(0xFF311c16),
  },
);

// Colors.brown[700]
const _primaryColorValue = 0xFF5e4037;

//Color
const primaryIconColor = Colors.black87;
const primaryColor = customSwatch;
final textButtonForeGroundColor = Colors.black87;
const textFieldFillColor = Color(0xFF424242); // = Colors.grey[800]
const darkThemeTextColor = Colors.white;
final lightThemeBackgroundColor = customSwatch[50];
const lightThemeTextColor = Color(0xFF303030); // = Colors.grey[850];
const darkThemeBackgroundColor =
    Color(0xFF303030); // = Colors.grey[850] = brightness.dark
const darkThemeButtonColor = Color(0xFF616161); // = Colors.grey[700]

//TextStyle
const lightThemeAppBarTitleTextStyle =
    TextStyle(color: lightThemeTextColor, fontSize: 18.0);
const darkThemeAppBarTitleTextStyle =
    TextStyle(color: darkThemeTextColor, fontSize: 18.0);

//--------------------------------------------------------------------------------Color
//Common
const nextScreenButtonColor = customSwatch;
final buttonNotEnabledColor = customSwatch[100];
const buttonEnabledColor = customSwatch;
const audioJournalButtonColor = Colors.white30;
final listTileColor = Colors.grey[700];
const notificationBadgeColor = Colors.redAccent;
final uploadingAppbarColor = Colors.black.withOpacity(0.3);
final uploadingBodyColor = Colors.black.withOpacity(0.5);
const darkBackgroundButtonColor = Color(0xFF616161); //= Colors.grey[700]

//Login
const googleIconButtonColor = Colors.white;

//Group
final currentUserListTileColor = customSwatch[400];
final memberListTitleColor = customSwatch[100];

//SendToGroup
final sendToGroupButtonColor = customSwatch;

//-------------------------------------------------------------------------------TextStyle
//Common

const buttonBlackTextStyle = TextStyle(fontSize: 18.0, color: Colors.black);
const buttonWhiteTextStyle = TextStyle(fontSize: 18.0, color: Colors.white);
const roundedRaisedButtonTextStyle =
    TextStyle(fontSize: 18.0, color: darkThemeTextColor);
const listTileTitleTextStyle = TextStyle(
  fontSize: 18.0,
);
const darkBackgroundListTileTextStyle =
    TextStyle(fontSize: 18.0, color: darkThemeTextColor);
const enabledButtonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const showConfirmDialogYesTextStyle = TextStyle(
  color: Colors.redAccent,
);
const timeDisplayTextStyle = TextStyle(
  fontSize: 32.0,
);
const instructionTextStyle = TextStyle(fontSize: 18.0);
const helpDialogOkayTextStyle = TextStyle(fontSize: 18.0);
const unavailableButtonTextStyle =
    TextStyle(color: Color(0xFF757575)); //= Colors.grey[600]

//Login
const slideDoneButtonTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white);
const slideDescriptionTextStyle =
    TextStyle(fontSize: 18.0, color: darkThemeTextColor);
const selfIntroTitleTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);
const selfIntroDescriptionTextStyle = TextStyle(
  fontSize: 16.0,
);
final skipButtonTextStyle = TextStyle(
  color: Colors.grey[500],
);
final underlineTextStyle = TextStyle(
  fontSize: 14.0,
  decoration: TextDecoration.underline,
);

//Profile
const profileLabelTextStyle = TextStyle(fontSize: 14.0);
const profileDescriptionTextStyle = TextStyle(
  fontSize: 18.0,
);

//Home
const homeScreenLabelTextStyle =
    TextStyle(fontSize: 16.0, color: darkThemeTextColor);
const newGroupIntroTextStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.grey);
const tutorialTextStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white);
const drawerHeaderTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white);

//JoinGroup
const groupDetailLabelTextStyle = TextStyle(
  fontSize: 14.0,
);
const groupDetailDescriptionTextStyle = TextStyle(
    fontSize: 16.0,
    color: Color(0xFFBDBDBD), //= Colors.grey[400]
    fontWeight: FontWeight.bold);

//Recording
const underButtonLabelTextStyle = TextStyle(
  fontSize: 18.0,
);
const preparationTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);
const audioJournalButtonTextStyle =
    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

//Group
const postTitleTextStyle = TextStyle(fontSize: 16.0, color: Colors.black87);
const postAudioDurationTextStyle =
    TextStyle(fontSize: 14.0, color: Colors.black54);
const GroupEditMenuCautionTextStyle =
    TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.red);
const groupEditMenuTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
);
const listenedDescriptionTextStyle =
    TextStyle(fontSize: 12.0, color: Colors.black54);
const uploadingDescriptionTextStyle =
    TextStyle(fontSize: 26.0, color: Colors.white);
const dateFormatTextStyle = TextStyle(fontSize: 14.0, color: Colors.grey);
