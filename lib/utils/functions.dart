import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

Future<File> createFileFromUrl(String strUrl) async {
  final http.Response responseData = await http.get(Uri.parse(strUrl));
  final unit8list = responseData.bodyBytes;
  final buffer = unit8list.buffer;
  ByteData byteData = ByteData.view(buffer);
  final tempDir = await getTemporaryDirectory();
  File file = await File("${tempDir.path}/img").writeAsBytes(
      buffer.asInt8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
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
