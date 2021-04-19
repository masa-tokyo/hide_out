import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

showHelpDialog(
    {
      @required BuildContext context,
      @required String contentString,
      @required String okayString,
    }
    ){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => HelpDialog(
        contentString: contentString,
        okayString: okayString,
      ));
}

class HelpDialog extends StatelessWidget {
  final String contentString;
  final String okayString;

  HelpDialog({this.contentString, this.okayString});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: hintDialogBackgroundColor,
        content: Text(contentString),
        actions: [
          Column(
            children: [
              Container(
                width: 1000,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide())
                ),
              ),
              TextButton(
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  child: Text(okayString, style: helpDialogOkayTextStyle,)),
            ],
          ),
        ],
      ),
    );
  }
}
