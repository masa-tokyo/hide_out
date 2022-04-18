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
  final String? memberId;
  final String? groupId;

  bool get isCurrentUser => memberId == null && groupId == null;

  ProfileScreen({this.memberId, this.groupId})
      : assert((memberId == null && groupId == null) ||
            (memberId != null && groupId != null));

  @override
  Widget build(BuildContext context) {
    if (!isCurrentUser) {
      Future(() =>
          context.read<ProfileViewModel>().fetchMember(groupId!, memberId!));
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Consumer<ProfileViewModel>(
          builder: (context, model, child) {
            return model.isProcessing
                ? SizedBox(
                    height: 0.7 * MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(children: [
                    SizedBox(
                      height: 24.0,
                    ),
                    _profilePicture(context, isCurrentUser),
                    SizedBox(
                      height: 24.0,
                    ),
                    _namePart(context, isCurrentUser, model),
                    SizedBox(
                      height: 24.0,
                    ),
                    _selfIntroPart(
                        context,
                        isCurrentUser
                            ? model.currentUser!.audioUrl
                            : model.member?.audioUrl ?? null),
                  ]);
          },
        ),
      ),
    );
  }

  Widget _profilePicture(BuildContext context, bool isCurrentUser) {
    return Consumer<ProfileViewModel>(
      builder: (_, model, __) {
        return isCurrentUser
            ? GestureDetector(
                onTap: () async {
                  final profileViewModel = context.read<ProfileViewModel>();
                  await profileViewModel.updateProfilePicture();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    UserAvatar(
                      url: model.currentUser!.photoUrl,
                      file: model.imageFile,
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
              )
            : UserAvatar(
                url: model.member?.photoUrl,
              );
      },
    );
  }

  Widget _namePart(
      BuildContext context, bool isCurrentUser, ProfileViewModel model) {
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
            if (isCurrentUser)
              GestureDetector(
                  onTap: () =>
                      _openUserInfoInputScreen(context, model.currentUser!),
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
          onTap: isCurrentUser
              ? () => _openUserInfoInputScreen(context, model.currentUser!)
              : null,
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
                    isCurrentUser
                        ? model.currentUser!.inAppUserName
                        : model.member?.name ?? '',
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

  Widget _selfIntroPart(BuildContext context, String? audioUrl) {
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
            if (isCurrentUser)
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SelfIntroRecordingScreen(
                              from: ProfileEditScreensOpenMode.PROFILE))),
                  child: Icon(
                    Icons.edit,
                    size: 20.0,
                  )),
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
                  audioUrl: audioUrl,
                  audioPlayType: AudioPlayType.SELF_INTRO)),
        ),
      ],
    );
  }
}
