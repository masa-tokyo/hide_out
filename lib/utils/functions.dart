
import 'package:flutter/material.dart';

Route<Object> createRoute(BuildContext context, Widget screen) {
  // bottom to top
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0); // Right to Left is Offset(1.0, 0.0)
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

unFocusKeyboard({required BuildContext context, Function? onUnFocused}) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (onUnFocused != null) onUnFocused();
  }
}

// consider the font size set on user preferences
TextStyle scaledFontTextStyle(TextStyle textStyle,
    {required double textScale}) {
  return textStyle.copyWith(fontSize: textStyle.fontSize! * textScale);
}
