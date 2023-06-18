import 'package:flutter/material.dart';
import 'package:hide_out/utils/style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UploadingPage extends StatelessWidget {
  const UploadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ColoredBox(
      color: uploadingBodyColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Uploading...",
              style: uploadingDescriptionTextStyle,
            ),
            SizedBox(
              height: 50.0,
            ),
            LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 48),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Please wait for a while.",
              style: uploadingDescriptionTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
