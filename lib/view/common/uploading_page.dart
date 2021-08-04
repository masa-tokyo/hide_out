import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';

class UploadingPage extends StatelessWidget {
  const UploadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: uploadingBodyColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Uploading...", style: uploadingDescriptionTextStyle,),
            SizedBox(height: 50.0,),
            CircularProgressIndicator(color: Colors.white,),
            SizedBox(height: 50.0,),
            Text("Please wait for a while.", style: uploadingDescriptionTextStyle,),
          ],
        ),
      ),
    );
  }
}
