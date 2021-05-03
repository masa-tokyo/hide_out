import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/group/components/audio_play_button.dart';
import 'package:voice_put/view/login/self_intro_recording_screen.dart';
import 'package:voice_put/view/login/user_name_input_screen.dart';
import 'package:voice_put/view_models/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  final bool isCurrentUser;
  final User user;

  ProfileScreen({@required this.isCurrentUser, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCurrentUser ? "Profile" : user.inAppUserName),
      ),
      body: Selector<ProfileViewModel, User>(
        selector: (context, viewModel) => viewModel.currentUser,
        builder: (context, currentUser, child) {
          return Column(children: [
            SizedBox(
              height: 24.0,
            ),
            isCurrentUser ? _namePart(context, currentUser) : Container(),
            SizedBox(
              height: 24.0,
            ),
            _selfIntroPart(context,
                isCurrentUser ? currentUser : user),
          ]);
        },
      ),
    );
  }

  Widget _namePart(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Name",
                style: profileLabelTextStyle,
              ),
            ),
            SizedBox(
              width: 24.0,
            ),
            GestureDetector(
                onTap: () =>
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) =>
                        UserNameInputScreen(
                          from: ProfileEditScreensOpenMode.PROFILE, name: user.inAppUserName,))),
                child: Icon(
                  Icons.edit,
                  size: 20.0,
                )),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: textFieldFillColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  user.inAppUserName,
                  style: profileDescriptionTextStyle,
                ),
              )),
        ),
      ],
    );
  }

  Widget _selfIntroPart(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Self-Introduction",
                style: profileLabelTextStyle,
              ),
            ),
            SizedBox(
              width: 24.0,
            ),
            isCurrentUser
                ? GestureDetector(
                onTap: () =>
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) =>
                        SelfIntroRecordingScreen(from: ProfileEditScreensOpenMode.PROFILE))),
                child: Icon(
                  Icons.mic,
                  size: 20.0,
                ))
                : Container(),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: textFieldFillColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AudioPlayButton(
                    //index: null,
                    audioUrl: user.audioUrl,
                    audioPlayType: AudioPlayType.SELF_INTRO)),
          ),
        ),
      ],
    );
  }
}
