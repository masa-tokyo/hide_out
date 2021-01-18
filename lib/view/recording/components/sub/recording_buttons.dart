import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class RecordingButtons extends StatefulWidget {
  @override
  _RecordingButtonsState createState() => _RecordingButtonsState();
}

class _RecordingButtonsState extends State<RecordingButtons> {
  RecordingButtonStatus _recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;
  FlutterSoundRecorder _flutterSoundRecorder = FlutterSoundRecorder();
  bool _isRecorderInitiated = false;
  String _path = "";

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();


  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _isRecorderInitiated = true;
      });
    });

    _stopWatchTimer.rawTime.listen((value) =>
    print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));

    super.initState();
  }

  @override
  void dispose() async{
    _stopRecording(); // in the case when status is DURING and not stopped.

    _flutterSoundRecorder.closeAudioSession();
    _flutterSoundRecorder = null;

    if (_path != null) {
      var outputFile = File(_path);
      if (outputFile.existsSync()){
        outputFile.delete();
      }
    }

    super.dispose();
    await _stopWatchTimer.dispose();

  }


  //------------------------------------------------------------------------------------------------------------------UI
  @override
  Widget build(BuildContext context) {

    var button;
    switch (_recordingButtonStatus){
      case RecordingButtonStatus.BEFORE_RECORDING:
        button = _beforeRecordingButton();
        break;
      case RecordingButtonStatus.DURING_RECORDING:
        button = _duringRecordingButton();
        break;
      case RecordingButtonStatus.AFTER_RECORDING:
        button = _afterRecordingButtons();
        break;
    }

    return Column(
      children: [
        SizedBox(height: 24.0,),
        _timeDisplay(),
        button
      ],
    );
  }

  //----------------------------------------------------------------------------------------------TimeDisplay
  Widget _timeDisplay() {
    return StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snapshot) {
          return Text(StopWatchTimer.getDisplayTime(
              snapshot.data,
              hours: snapshot.data < 3600000
              ? false
              : true,
              milliSecond: false));
        }
    );

  }


  //----------------------------------------------------------------------------------------------BEFORE_RECORDING
  Widget _beforeRecordingButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardCircle(context),
      ],
    );
  }

  Widget _backwardCircle() {
    return  Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _forwardCircle(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      child: RaisedButton(
        onPressed: () => _onCircleButtonPressed(context),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: CircleBorder(
        ),
      ),
    );
  }

  _onCircleButtonPressed(BuildContext context) async{
    //start recording
    if (!_isRecorderInitiated) {
      print("recorder is not initiated");
      return null;
    }

    await _startRecording();

    //start stopwatch
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);


    //change RecordingButtonStatus from BEFORE to DURING
    _recordingButtonStatus = RecordingButtonStatus.DURING_RECORDING;
    setState(() {});

  }

//----------------------------------------------------------------------------------------------DURING_RECORDING
  Widget _duringRecordingButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _backwardCircle(),
        _forwardRectangle(context),
      ],
    );
  }

  Widget _forwardRectangle(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: RaisedButton(
        onPressed: () => _onRectangleButtonPressed(context),
        elevation: 3.0,
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  _onRectangleButtonPressed(BuildContext context) async{
    //stop recording
    await _stopRecording();

    //finish stopwatch
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);


    //change RecordingButtonStatus from DURING to AFTER
    _recordingButtonStatus = RecordingButtonStatus.AFTER_RECORDING;
    setState(() {});


  }

//----------------------------------------------------------------------------------------------AFTER_RECORDING

  Widget _afterRecordingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _againButton(context),
        _sendButton(),
      ],
    );
  }

  Widget _againButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: RaisedButton(
            elevation: 3.0,
            onPressed: () => _onAgainButtonPressed(context),
            child: FaIcon(FontAwesomeIcons.undo, size: 30.0,),
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 8.0,),
        Text("Again", style: underButtonLabelTextStyle,),
      ],
    );
  }

  _onAgainButtonPressed(BuildContext context) async{

    //todo pop up dialog to make sure?


    //delete the recording
    var outputFile = File(_path);
    if (outputFile.existsSync()){
      outputFile.delete();
    }


    //reset stopwatch
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);



    //change RecordingButtonStatus from AFTER to BEFORE
    _recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;
    setState(() {});

  }

  Widget _sendButton() {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: RaisedButton(
            elevation: 3.0,
            onPressed: () => _onSendButtonPressed(),
            child: Icon(Icons.send, size: 30.0,),
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 8.0,),
        Text("Send", style: underButtonLabelTextStyle,),
      ],
    );
  }

  _onSendButtonPressed() async{


    _stopWatchTimer.rawTime.listen((event) async{
      var displayTime;

      displayTime =  StopWatchTimer.getDisplayTime(event,
          hours: event < 3600000
              ? false
              : true,
          milliSecond: false);

      //post the recording
      final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
      await recordingViewModel.postRecording(_path, displayTime);


    });


     Navigator.pop(context);

    //todo show toast message "post was successful"

  }

//------------------------------------------------------------------------------------------------------------------Recording Methods

 Future<void> openTheRecorder() async {
   //upgraded the minimum SDK version of Android(23) & minimum OS version of iOS(10.0)

    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    var temDir = await getTemporaryDirectory();
    _path = "${temDir.path}/flutter_sound_example.aac";
    var outputFile = File(_path);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await _flutterSoundRecorder.openAudioSession();
    //todo [check]  "_isRecorderInitiated = true;" necessary?
 }


  Future<void> _startRecording() async{

    assert(_isRecorderInitiated);
    await _flutterSoundRecorder.startRecorder(
      toFile: _path,
      codec: Codec.aacADTS,
    );



    //todo [check] is SetState() necessary?
    setState(() {

    });

  }

  Future<void> _stopRecording() async{
    await _flutterSoundRecorder.stopRecorder();

    //todo [check] is SetState() necessary?
    // setState(() {
    //
    // });

  }




}
