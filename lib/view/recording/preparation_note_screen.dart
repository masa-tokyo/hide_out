import 'package:flutter/material.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/recording/recording_screen.dart';

class PreparationNoteScreen extends StatefulWidget {
  @override
  _PreparationNoteScreenState createState() => _PreparationNoteScreenState();
}

class _PreparationNoteScreenState extends State<PreparationNoteScreen> {
  TextEditingController _controller = TextEditingController();
  bool _isNextButtonAvailable = false;
  bool _isTyping = false;

  @override
  void initState() {
    _controller.addListener(_onTextFieldUpdated);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unFocusKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: _isTyping ? Container() : Center(child: Text("Preparation 3/3")),
          actions: [
            _isTyping
                ? TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _isTyping = false;
                });
              },
              child: Icon(Icons.keyboard_arrow_down),
            )
                : TextButton(
                onPressed: () => _openRecordingScreen(),
                child: Text("Skip")),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _textField(),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  _textField() {
    var maxLines = 12;
    return Column(
      children: [
        SizedBox(height: 8.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: TextField(
            controller: _controller,
            maxLines: maxLines,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Make a brief summary of your idea.",
              filled: true,
            ),
            onTap: () => _onTextFieldTapped(),
          ),
        ),
      ],
    );
  }

  _onTextFieldTapped() {
    setState(() {
      _isTyping = true;
    });
  }


  _nextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                _isNextButtonAvailable ? buttonEnabledColor : buttonNotEnabledColor
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),),
            ),
            onPressed: () => _isNextButtonAvailable ? _openRecordingScreen() : null,
            child: Text(
              "Next",
              style: _isNextButtonAvailable ? buttonEnabledTextStyle : buttonNotEnabledTextStyle,
            )),
      ),
    );
  }

  _openRecordingScreen() async {
    await Navigator.push(
      context, MaterialPageRoute(builder: (_) => RecordingScreen(noteText: _controller.text),),);
    FocusScope.of(context).unfocus();
    _isTyping = false;
  }


  _onTextFieldUpdated() {
    if (_controller.text.isEmpty) {
      setState(() {
        _isNextButtonAvailable = false;
      });
    } else {
      setState(() {
        _isNextButtonAvailable = true;
      });
    }
  }

  _unFocusKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
      setState(() {
        _isTyping = false;
      });
    }
  }
}