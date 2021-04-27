import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/components/sub/post_title_input_text_field.dart';
import 'package:voice_put/view/recording/send_to_group_screen.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class PostTitleScreen extends StatelessWidget {
  final String path;
  final String audioDuration;
  final RecordingOpenMode from;
  final Group group;

  PostTitleScreen({@required this.audioDuration, @required this.path, @required this.from, @required this.group});

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
          _nextOrDoneButton(context)
        ],
      ),
    );
  }

  Widget _nextOrDoneButton(BuildContext context) {
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
            onPressed: () => _onButtonPressed(context),
            child: Text(from == RecordingOpenMode.FROM_HOME
              ? "Next" : "Done",
              style: enabledButtonTextStyle,),
        ),
      ),
    );
  }

  _onButtonPressed(BuildContext context) async{
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }

    if (from == RecordingOpenMode.FROM_HOME){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SendToGroupScreen(audioDuration: audioDuration, path: path)));
    } else {
      //post
      recordingViewModel.addGroupId(group.groupId);
      await recordingViewModel.postRecording(path, audioDuration);

      //back to GroupScreen
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      recordingViewModel.updateRecordingButtonStatus(RecordingButtonStatus.BEFORE_RECORDING);

      Fluttertoast.showToast(msg: "Done", gravity: ToastGravity.CENTER);

    }

  }
}
