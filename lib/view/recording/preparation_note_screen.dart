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
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Note")),
        actions: [
          FlatButton(
              onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Icon(Icons.done),
              // shape: CircleBorder(side: BorderSide(
              //   color:Colors.transparent
              // )),
          ),
          FlatButton(
              onPressed: () => _openRecordingScreen(),
              child: Text("Skip")),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Preparation",
                style: preparationTextStyle,
              ),
              _textField(),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  _textField() {
    var maxLines = 20;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: _controller,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Make a brief summary of your idea.",
        ),
      ),
    );
  }

  _nextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: _isNextButtonAvailable ? Colors.lightBlue : Colors.grey,
            onPressed: () => _isNextButtonAvailable ? _openRecordingScreen() : null,
            child: Text(
              "Next",
              style: _isNextButtonAvailable ? buttonEnabledTextStyle : buttonNotEnabledTextStyle,
            )),
      ),
    );
  }

  _openRecordingScreen() {
    Navigator.push(
      context, MaterialPageRoute(builder: (_) => RecordingScreen(noteText: _controller.text),),);
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
}
