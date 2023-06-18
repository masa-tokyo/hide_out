import 'package:flutter/material.dart';
import 'package:hide_out/utils/style.dart';

showHelpDialog({
  required BuildContext context,
  required String contentString,
  required String okayString,
  VoidCallback? onConfirmed,
  Text? title,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => HelpDialog(
            contentString: contentString,
            okayString: okayString,
            onConfirmed: onConfirmed,
            title: title,
          ));
}

class HelpDialog extends StatelessWidget {
  final String contentString;
  final String okayString;
  final VoidCallback? onConfirmed;
  final Text? title;

  HelpDialog(
      {required this.contentString,
      required this.okayString,
      this.onConfirmed,
      this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Center(child: title),
        content: Text(
          contentString,
          textAlign: TextAlign.center,
        ),
        actions: [
          Column(
            children: [
              Divider(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onConfirmed != null) {
                        onConfirmed!();
                      }
                    },
                    child: Text(
                      okayString,
                      style: helpDialogOkayTextStyle,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
