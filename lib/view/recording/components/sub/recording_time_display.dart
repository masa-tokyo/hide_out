import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingTimeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<RecordingViewModel>(
        builder: (context, model, child){
          return Text(model.timeText);
        });
  }
}
