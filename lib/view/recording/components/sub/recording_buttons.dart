import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/dialog/confirm_dialog.dart';
import 'package:hide_out/view/join_group/join_group_screen.dart';
import 'package:hide_out/view/recording/post_title_screen.dart';
import 'package:hide_out/view_models/recording_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class RecordingButtons extends StatefulWidget {
  final RecordingButtonOpenMode from;
  final Group? group;

  RecordingButtons({
    required this.from,
    required this.group,
  });

  @override
  _RecordingButtonsState createState() => _RecordingButtonsState();
}

class _RecordingButtonsState extends State<RecordingButtons> {
  RecordingButtonStatus _recordingButtonStatus =
      RecordingButtonStatus.BEFORE_RECORDING;

  StreamSubscription? _recorderSubscription;
  FlutterSoundRecorder? _flutterSoundRecorder = FlutterSoundRecorder();
  bool _isRecorderInitiated = false;
  String _path = "";
  Duration _duration = Duration();

  @override
  void initState() {
    super.initState();

    openTheRecorder().then((value) {
      setState(() {
        _isRecorderInitiated = true;
      });
      _setSubscriptionDuration();
    });
  }

  Future<void> _setSubscriptionDuration() async {
    await _flutterSoundRecorder!.setSubscriptionDuration(Duration(seconds: 1));
  }

  @override
  void dispose() async {
    _stopRecording(); // in the case when status is DURING and not stopped.

    _flutterSoundRecorder!.closeAudioSession();
    _flutterSoundRecorder = null;

    var outputFile = File(_path);
    if (outputFile.existsSync()) {
      outputFile.delete();
    }

    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }

    super.dispose();
  }

  //----------------------------------------------------------------------------UI
  @override
  Widget build(BuildContext context) {
    var button;
    switch (_recordingButtonStatus) {
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
        _recordingButtonStatus == RecordingButtonStatus.DURING_RECORDING
            ? _timeDisplay()
            : Container(),
        SizedBox(
          height: 8.0,
        ),
        button
      ],
    );
  }

  //----------------------------------------------------------------------------TimeDisplay
  Widget _timeDisplay() {
    return StreamBuilder<RecordingDisposition>(
        stream: _flutterSoundRecorder!.onProgress,
        initialData: RecordingDisposition.zero(),
        builder: (context, snapshot) {
          var txt = snapshot.data!.duration.toString().substring(2, 7);
          return Text(
            txt,
            style: timeDisplayTextStyle,
          );
        });
  }

  //----------------------------------------------------------------------------BEFORE_RECORDING
  Widget _beforeRecordingButton() {
    return Column(
      children: [
        SizedBox(
          width: 100.0,
          height: 100.0,
          child: ElevatedButton(
            onPressed: () => _onCircleButtonPressed(context),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(3.0),
              backgroundColor: MaterialStateProperty.all(customSwatch),
              shape: MaterialStateProperty.all(CircleBorder()),
            ),
            child: const FaIcon(
              FontAwesomeIcons.solidCommentDots,
              size: 42,
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text('Start'),
      ],
    );
  }

  _onCircleButtonPressed(BuildContext context) async {
    try {
      //start recording
      if (!_isRecorderInitiated) {
        print("recorder is not initiated");
        return null;
      }

      await _startRecording();

      setState(() {
        //change RecordingButtonStatus from BEFORE to DURING
        _recordingButtonStatus = RecordingButtonStatus.DURING_RECORDING;
      });
      final recordingViewModel =
          Provider.of<RecordingViewModel>(context, listen: false);
      await recordingViewModel
          .updateRecordingButtonStatus(_recordingButtonStatus);
    } catch (e) {
      print("error: $e");
    }
  }

//------------------------------------------------------------------------------DURING_RECORDING
  Widget _duringRecordingButton() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _backwardCircle(),
            _forwardSquare(context),
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text('Stop'),
      ],
    );
  }

  Widget _backwardCircle() {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: customSwatch,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _forwardSquare(BuildContext context) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: ElevatedButton(
        onPressed: () => _onRectangleButtonPressed(context),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(3.0),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }

  _onRectangleButtonPressed(BuildContext context) async {
    //stop recording
    await _stopRecording();

    //change RecordingButtonStatus from DURING to AFTER
    setState(() {
      _recordingButtonStatus = RecordingButtonStatus.AFTER_RECORDING;
    });

    final recordingViewModel =
        Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel
        .updateRecordingButtonStatus(_recordingButtonStatus);
  }

//------------------------------------------------------------------------------AFTER_RECORDING

  Widget _afterRecordingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _againButton(context),
        _finishButton(),
      ],
    );
  }

  Widget _againButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(3.0),
              shape: MaterialStateProperty.all(CircleBorder()),
            ),
            onPressed: () => _onAgainButtonPressed(context),
            child: FaIcon(
              FontAwesomeIcons.undo,
              size: 30.0,
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Again",
          style: underButtonLabelTextStyle,
        ),
      ],
    );
  }

  _onAgainButtonPressed(BuildContext context) async {
    //delete the recording
    var outputFile = File(_path);
    if (outputFile.existsSync()) {
      outputFile.delete();
    }

    setState(() {
      //change RecordingButtonStatus from AFTER to BEFORE
      _recordingButtonStatus = RecordingButtonStatus.BEFORE_RECORDING;
    });

    final recordingViewModel =
        Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel
        .updateRecordingButtonStatus(_recordingButtonStatus);
  }

  Widget _finishButton() {
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(3.0),
              shape: MaterialStateProperty.all(CircleBorder()),
            ),
            onPressed: () => _onFinishButtonPressed(),
            child: Icon(
              Icons.done_rounded,
              size: 50.0,
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Done",
          style: underButtonLabelTextStyle,
        ),
      ],
    );
  }

  _onFinishButtonPressed() async {
    var audioDuration = _duration.toString().substring(2, 7);

    if (widget.from == RecordingButtonOpenMode.POST_FROM_HOME ||
        widget.from == RecordingButtonOpenMode.POST_FROM_GROUP) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostTitleScreen(
            path: _path,
            audioDuration: audioDuration,
            from: widget.from,
            group: widget.group,
          ),
        ),
      );
    } else if (widget.from == RecordingButtonOpenMode.SELF_INTRO_FROM_SIGN_UP) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => JoinGroupScreen(isSignedUp: true)));

      final recordingViewModel =
          Provider.of<RecordingViewModel>(context, listen: false);
      await recordingViewModel.uploadSelfIntro(_path);
    } else {
      //widget.from == RecordingButtonOpenMode.SELF_INTRO_FROM_PROFILE

      final recordingViewModel =
          Provider.of<RecordingViewModel>(context, listen: false);
      await recordingViewModel.uploadSelfIntro(_path);

      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: "Done!",
        gravity: ToastGravity.CENTER,
      );
    }
  }

//------------------------------------------------------------------------------Recording Methods

  Future<void> openTheRecorder() async {
    //upgraded the minimum SDK version of Android(23) & minimum OS version of iOS(10.0)

    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      showConfirmDialog(
        context: context,
        titleString: "Microphone Settings",
        contentString: "Please enable Microphone in the settings.",
        onConfirmed: (isConfirmed) {
          if (isConfirmed) {
            openAppSettings();
          }
        },
        yesText: Text("OK"),
        noText: Text("Don't Allow"),
      );
    }
    var temDir = await getTemporaryDirectory();
    _path = "${temDir.path}/flutter_sound_example.aac";
    var outputFile = File(_path);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await _flutterSoundRecorder!.openAudioSession();
  }

  Future<void> _startRecording() async {
    assert(_isRecorderInitiated);
    await _flutterSoundRecorder!.startRecorder(
      toFile: _path,
      codec: Codec.aacADTS,
    );

    _recorderSubscription = _flutterSoundRecorder!.onProgress!.listen((event) {
      _duration = event.duration;
    });
  }

  Future<void> _stopRecording() async {
    await _flutterSoundRecorder!.stopRecorder();
  }
}
