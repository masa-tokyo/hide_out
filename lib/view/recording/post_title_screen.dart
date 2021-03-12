import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/components/sub/post_title_input_text_field.dart';
import 'package:voice_put/view/recording/send_to_group_screen.dart';

class PostTitleScreen extends StatelessWidget {
  final String path;
  final String audioDuration;

  PostTitleScreen({@required this.audioDuration, @required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          PostTitleInputTextField(),
          SizedBox(
            height: 72.0,
          ),
          _nextButton(context)
        ],
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(3.0),
              backgroundColor: MaterialStateProperty.all(nextScreenButtonColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),),
            ),
            onPressed: () => _openSendToGroupScreen(context),
            child: Text(
              "Next",
              style: buttonEnabledTextStyle,
            )),
      ),
    );
  }

  _openSendToGroupScreen(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SendToGroupScreen(audioDuration: audioDuration, path: path)));
  }
}
