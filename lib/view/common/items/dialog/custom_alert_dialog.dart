import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

showCustomAlertDialog({
  required BuildContext context,
  required String titleStr,
  required String contentStr,
  VoidCallback? onConfirmed,
  required String confirmedStr,
  required Color circleColor,
  required Icon icon,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomAlertDialog(
            titleStr: titleStr,
            contentStr: contentStr,
            onConfirmed: onConfirmed,
            confirmStr: confirmedStr,
            circleColor: circleColor,
            icon: icon,
          ));
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.titleStr,
    required this.contentStr,
    this.onConfirmed,
    required this.confirmStr,
    required this.circleColor,
    required this.icon,
  });

  final String titleStr;
  final String contentStr;
  final VoidCallback? onConfirmed;
  final String confirmStr;
  final Color circleColor;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  height: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50.0, left: 12.0, right: 12.0, bottom: 12.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                titleStr,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                contentStr,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (onConfirmed != null) {
                                  onConfirmed!();
                                }
                              },
                              child: Text(confirmStr)),
                        ]),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(FontAwesomeIcons.times)),
              ],
            ),
            Positioned(
              top: -20,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: circleColor,
                child: icon,
              ),
            ),
          ]),
    );
  }
}
