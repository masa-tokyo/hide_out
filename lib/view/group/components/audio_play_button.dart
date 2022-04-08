import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/view/common/items/dialog/help_dialog.dart';
import 'package:hide_out/view_models/group_view_model.dart';
import 'package:provider/provider.dart';

class AudioPlayButton extends StatefulWidget {
  final String? audioUrl;
  final AudioPlayType audioPlayType;
  final Post? post;
  final Color? color;

  AudioPlayButton(
      {required this.audioUrl,
      required this.audioPlayType,
      this.post,
      this.color});

  @override
  _AudioPlayButtonState createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AudioWidget.network(
      url: widget.audioUrl ?? '',
      play: _isPlaying,
      loopMode: LoopMode.single,
      child: !_isPlaying ? _notPlayingButton() : _duringPlayingButton(),
      onFinished: () => _onAudioFinished(),
    );
  }

  _onAudioFinished() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  //------------------------------------------------------------------------------------------------- NOT_PLAYING

  Widget _notPlayingButton() {
    return InkWell(
      onTap: () => _onNotPlayingButtonPressed(),
      child: Card(
        color: widget.color,
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child: Icon(
            Icons.play_arrow,
            size: 36.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  _onNotPlayingButtonPressed() {
    if (widget.audioUrl != "") {
      final groupViewModel =
          Provider.of<GroupViewModel>(context, listen: false);
      if (widget.audioPlayType == AudioPlayType.POST_OTHERS) {
        groupViewModel.insertListener(widget.post!);
        groupViewModel.deleteNotification(postId: widget.post!.postId);
      }

      setState(() {
        _isPlaying = !_isPlaying;
      });
    } else {
      showHelpDialog(
          context: context,
          contentString: "No Recording yet!",
          okayString: "Okay",
          onConfirmed: null);
    }
  }

  //-------------------------------------------------------------------------------------------------DURING_PLAYING

  Widget _duringPlayingButton() {
    return InkWell(
      onTap: () => _onDuringPlayingButtonPressed(),
      child: Card(
        color: widget.color,
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child: Icon(
            Icons.pause,
            size: 36.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  _onDuringPlayingButtonPressed() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
}
