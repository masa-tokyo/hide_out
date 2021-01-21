import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/recording_screen.dart';
import 'package:voice_put/view_models/group_view_model.dart';

import 'components/audio_play_button.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  GroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);
    Future(() => groupViewModel.getGroupPosts(group));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_voice),
        onPressed: () => _openRecordingScreen(context),
      ),
      appBar: AppBar(
        title: Text(group.groupName),
        actions: [_groupEditButton()],
        //todo when coming from StartGroupScreen, change back_arrow to close button
      ),
      body: RefreshIndicator(
          onRefresh: () => groupViewModel.getGroupPosts(group),
          child: _postListView(context)),
    );
  }

  //---------------------------------------------------------------------------------------------- Other than body


  Widget _groupEditButton() {
    return IconButton(
      icon: Icon(Icons.more_vert),
      //todo show pop up menu
      onPressed: null,
    );
  }

  _openRecordingScreen(BuildContext context) {
    Navigator.of(context).push(_createRoute(context));

  }

  Route<Object> _createRoute(BuildContext context) {

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RecordingScreen(group: group,),
        transitionsBuilder: (context, animation, secondaryAnimation, child){
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,);

        });
  }



//---------------------------------------------------------------------------------------------- body

  Widget _postListView(BuildContext context) {
    return Consumer<GroupViewModel>(
      builder: (context, model, child){
        return model.isProcessing
            ? Center(child: CircularProgressIndicator(),)
            : ListView.builder(
            itemCount: model.posts.length,
            itemBuilder: (context, int index){
              final post = model.posts[index];
              return Card(
                elevation: 2.0,
                child: ListTile(
                  trailing: AudioPlayButton(audioUrl: post.audioUrl),
                  subtitle: Text(post.userName),
                  title: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: post.title, style: postTitleTextStyle),
                            TextSpan(text: "  "),
                            TextSpan(text: "(${post.audioDuration})", style: postAudioDurationTextStyle),
                          ]
                      )),
                ),
              );
            });
      },
    );
  }


}
