import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

showHelpDialog(
    {
      @required BuildContext context,
      @required String contentString,
      @required String okayString,
      @required VoidCallback onConfirmed,
      Text title,
    }
    ){
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
  final VoidCallback onConfirmed;
  final Text title;

  HelpDialog({this.contentString, this.okayString, this.onConfirmed, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: hintDialogBackgroundColor,
        title: Center(child: title),
        content: Text(contentString),
        actions: [
          Column(
            children: [
              Container(
                width: 1000,
              ),
              Divider(),
              TextButton(
                  onPressed:(){
                    Navigator.pop(context);
                    onConfirmed();
                  },
                  child: Text(okayString, style: helpDialogOkayTextStyle,)),
            ],
          ),
        ],
      ),
    );
  }
}
