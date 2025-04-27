import 'package:flutter/material.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';

class HelpIcon extends StatelessWidget {
  final String message;
  HelpIcon({required this.message});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.help_outline),
        tooltip: message,
        onPressed: () => showHelpDialog(
          context: context,
          contentString: message,
          onConfirmed: () => null,
          okayString: "Okay",
        ));
  }
}
