import 'package:flutter/material.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/recording/components/post_title_part.dart';
import 'package:voice_put/view/recording/components/recording_button_part.dart';

class RecordingScreen extends StatelessWidget {
  final Group group;

  RecordingScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Recording"),
        leading: _closeButton(context),
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PostTitlePart(),
          SizedBox(height: 1.0,),
          SizedBox(height: 1.0,),
          SizedBox(height: 1.0,),
          RecordingButtonPart(group: group,),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, color: Colors.white,),
      //todo disable Navigator.pop while DURING_RECORDING
      onPressed: () => Navigator.pop(context),);
  }
}
