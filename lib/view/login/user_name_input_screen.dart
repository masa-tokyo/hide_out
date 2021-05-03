import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/constants.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/login/self_intro_recording_screen.dart';
import 'package:voice_put/view_models/profile_view_model.dart';

class UserNameInputScreen extends StatefulWidget {
  final ProfileEditScreensOpenMode from;
  final String name;

  UserNameInputScreen({@required this.from, this.name});

  @override
  _UserNameInputScreenState createState() => _UserNameInputScreenState();
}

class _UserNameInputScreenState extends State<UserNameInputScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.from == ProfileEditScreensOpenMode.PROFILE) {
      _controller.text = widget.name;
    }

    _controller.addListener(_onTextUpdated);

    super.initState();
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
        title: Text("Name"),
      ),
      body: Column(
        children: [
          SizedBox(height: 32.0,),
          _textField(),
          SizedBox(height: 48.0),
          _button(),
        ],
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: _controller,
        //todo not enable to withdraw keyboard
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

  _onTextUpdated() {
    setState(() {});
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
                        : buttonEnabledColor
                )
            ),
            onPressed: () => _controller.text.isEmpty ? null : _onButtonPressed(),
            child: widget.from == ProfileEditScreensOpenMode.SIGN_UP
                ? Text("Next", style: enabledButtonTextStyle)
                : Text("Done", style: enabledButtonTextStyle,)),
      ),
    );
  }

  _onButtonPressed() {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);

    //update username
    profileViewModel.updateUserName(_controller.text);

    if(widget.from == ProfileEditScreensOpenMode.SIGN_UP){
      //go to JoinGroupScreen
      Navigator.push(context, MaterialPageRoute(builder: (_) => SelfIntroRecordingScreen(from: ProfileEditScreensOpenMode.SIGN_UP,)));
    } else{
      Navigator.pop(context);
    }

  }
}
