import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/post.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/view_models/group_view_model.dart';
import 'package:provider/provider.dart';

class PostAudioPlayButton extends StatefulWidget {
  final int index;
  final AudioPlayType audioPlayType;
  final Post? post;
  final Color color;

  PostAudioPlayButton({
    required this.audioPlayType,
    this.post,
    required this.index,
    required this.color,
  });

  @override
  _PostAudioPlayButtonState createState() => _PostAudioPlayButtonState();
}

class _PostAudioPlayButtonState extends State<PostAudioPlayButton> {
  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    return FutureBuilder(
        future: groupViewModel.returnIsPlaying(widget.index),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            final _isPlaying = snapshot.data!;

            return !_isPlaying ? _notPlayingButton() : _duringPlayingButton();
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  //---------------------------------------------------------------------------- NOT_PLAYING

  Widget _notPlayingButton() {
    return GestureDetector(
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
      final groupViewModel =
          Provider.of<GroupViewModel>(context, listen: false);
      if (widget.audioPlayType == AudioPlayType.POST_OTHERS) {
        groupViewModel.insertListener(widget.post!);
        groupViewModel.deleteNotification(postId: widget.post!.postId);
      }

      groupViewModel.playAudio(widget.index, widget.audioPlayType);


  }

  //----------------------------------------------------------------------------DURING_PLAYING

  Widget _duringPlayingButton() {
    return GestureDetector(
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
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    groupViewModel.pauseAudio();
  }
}
