import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/utils/style.dart';

showConfirmDialog({
  required BuildContext context,
  required String titleString,
  required String contentString,
  required ValueChanged<bool> onConfirmed,
  required Text yesText,
  required Text noText,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        if (Platform.isIOS) {
          return CupertinoConfirmDialog(
            titleString: titleString,
            contentString: contentString,
            onConfirmed: onConfirmed,
            yesText: yesText,
            noText: noText,
          );
        } else {
          return ConfirmDialog(
            titleString: titleString,
            contentString: contentString,
            onConfirmed: onConfirmed,
            yesText: yesText,
            noText: noText,
          );
        }
      });
}

class ConfirmDialog extends StatelessWidget {
  final String? titleString;
  final String? contentString;
  final ValueChanged<bool>? onConfirmed;
  final Text? yesText;
  final Text? noText;

  ConfirmDialog(
      {this.onConfirmed,
      this.contentString,
      this.noText,
      this.titleString,
      this.yesText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: confirmDialogBackgroundColor,
      title: Center(child: Text(titleString!)),
      content: Text(contentString!),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed!(false);
            },
            child: noText!),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed!(true);
            },
            child: yesText!),
      ],
    );
  }
}

class CupertinoConfirmDialog extends StatelessWidget {
  final String? titleString;
  final String? contentString;
  final ValueChanged<bool>? onConfirmed;
  final Text? yesText;
  final Text? noText;

  CupertinoConfirmDialog(
      {this.onConfirmed,
      this.contentString,
      this.noText,
      this.titleString,
      this.yesText});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Center(child: Text(titleString!)),
      content: Text(contentString!),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed!(false);
            },
            child: noText!),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed!(true);
            },
            child: yesText!),
      ],
    );
  }
}
