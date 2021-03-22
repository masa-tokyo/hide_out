import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/join_group/join_group_screen.dart';
import 'package:voice_put/view_models/login_view_model.dart';

class UserNameInputScreen extends StatefulWidget {
  @override
  _UserNameInputScreenState createState() => _UserNameInputScreenState();
}

class _UserNameInputScreenState extends State<UserNameInputScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
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
        leading: null,
        title: Text("Name"),
      ),
      body: Column(
        children: [
          SizedBox(height: 32.0,),
          _textField(),
          SizedBox(height: 48.0),
          _nextButton(),
        ],
      ),
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

  _onTextUpdated(){
    setState(() {
    });
  }

  Widget _nextButton() {
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
            onPressed: () => _controller.text.isEmpty ? null : _onNextButtonPressed(),
            child: Text("Next", style: enablingButtonTextStyle,)),
      ),
    );
  }

  _onNextButtonPressed() {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    //update username
    loginViewModel.updateUserName(_controller.text);

    //go to JoinGroupScreen
    Navigator.push(context, MaterialPageRoute(builder: (_) => JoinGroupScreen(isSignedUp: true,)));

  }
}
