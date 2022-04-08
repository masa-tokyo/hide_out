import 'package:flutter/material.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/user_avatar.dart';
import 'package:hide_out/view/login/self_intro_recording_screen.dart';
import 'package:hide_out/view_models/login_view_model.dart';
import 'package:hide_out/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class UserInfoInputScreen extends StatefulWidget {
  final ProfileEditScreensOpenMode from;
  final String? name;

  UserInfoInputScreen({required this.from, this.name});

  @override
  _UserInfoInputScreenState createState() => _UserInfoInputScreenState();
}

class _UserInfoInputScreenState extends State<UserInfoInputScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.from == ProfileEditScreensOpenMode.PROFILE) {
      _controller.text = widget.name!;
    }
    _controller.addListener(_onTextUpdated);
    super.initState();
  }

  _onTextUpdated() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.from == ProfileEditScreensOpenMode.SIGN_UP
            ? Text("Info")
            : Text("Name"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 24.0,
          ),
          widget.from == ProfileEditScreensOpenMode.SIGN_UP
              ? _profilePicture()
              : Container(),
          SizedBox(
            height: 32.0,
          ),
          _textField(),
          SizedBox(height: 48.0),
          _button(),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return Consumer<LoginViewModel>(
      builder: (_, model, __) {
        return GestureDetector(
          onTap: () async {
            final loginViewModel = context.read<LoginViewModel>();
            await loginViewModel.updateProfilePicture();
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(
                url: model.currentUser!.photoUrl,
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

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "Type your nickname.",
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    _controller.text.isEmpty
                        ? buttonNotEnabledColor
                        : buttonEnabledColor)),
            onPressed: () =>
                _controller.text.isEmpty ? null : _onButtonPressed(),
            child: widget.from == ProfileEditScreensOpenMode.SIGN_UP
                ? Text("Next", style: enabledButtonTextStyle)
                : Text(
                    "Done",
                    style: enabledButtonTextStyle,
                  )),
      ),
    );
  }

  _onButtonPressed() {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    //update username
    profileViewModel.updateUserName(_controller.text);

    if (widget.from == ProfileEditScreensOpenMode.SIGN_UP) {
      //go to JoinGroupScreen
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SelfIntroRecordingScreen(
                    from: ProfileEditScreensOpenMode.SIGN_UP,
                  )));
    } else {
      Navigator.pop(context);
    }
  }
}
