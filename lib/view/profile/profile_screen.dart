import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/user_avatar.dart';
import 'package:hide_out/view/group/components/audio_play_button.dart';
import 'package:hide_out/view/login/self_intro_recording_screen.dart';
import 'package:hide_out/view/login/user_info_input_screen.dart';
import 'package:hide_out/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final bool isCurrentUser;
  final User? user;

  ProfileScreen({required this.isCurrentUser, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCurrentUser ? "Profile" : user!.inAppUserName!),
      ),
      body: SingleChildScrollView(
        child: Selector<ProfileViewModel, User?>(
          selector: (context, viewModel) => viewModel.currentUser,
          builder: (context, currentUser, child) {
            return Column(children: [
              SizedBox(
                height: 24.0,
              ),
              _profilePicture(context),
              SizedBox(
                height: 24.0,
              ),
              isCurrentUser ? _namePart(context, currentUser!) : Container(),
              SizedBox(
                height: 24.0,
              ),
              _selfIntroPart(context, isCurrentUser ? currentUser! : user!),
            ]);
          },
        ),
      ),
    );
  }

  Widget _profilePicture(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (_, model, __) {
        return GestureDetector(
          onTap: () async {
            final profileViewModel = context.read<ProfileViewModel>();
            await profileViewModel.updateProfilePicture();
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(
                url: model.currentUser!.photoUrl!,
                file: model.imageFile ?? null,
              ),
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      },
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
                onTap: () => _openUserInfoInputScreen(context, user),
                child: Icon(
                  Icons.edit,
                  size: 20.0,
                )),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        GestureDetector(
          onTap: () => _openUserInfoInputScreen(context, user),
          child: Padding(
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
                    user.inAppUserName!,
                    style: profileDescriptionTextStyle,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  _openUserInfoInputScreen(BuildContext context, User user) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UserInfoInputScreen(
                  from: ProfileEditScreensOpenMode.PROFILE,
                  name: user.inAppUserName,
                )));
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SelfIntroRecordingScreen(
                                from: ProfileEditScreensOpenMode.PROFILE))),
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
        SizedBox(
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AudioPlayButton(
                  color: listTileColor,
                  audioUrl: user.audioUrl,
                  audioPlayType: AudioPlayType.SELF_INTRO)),
        ),
      ],
    );
  }
}
