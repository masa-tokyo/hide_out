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
    return Scaffold(
      appBar: AppBar(
        title: _isTyping ? Container() : Center(child: Text("Note")),
        actions: [
          _isTyping
          ? FlatButton(
              onPressed: (){
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _isTyping = false;
                });
              },
              child: Icon(Icons.keyboard_arrow_down),
          )
          : FlatButton(
              onPressed: () => _openRecordingScreen(),
              child: Text("Skip")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround
          ,
          children: [
            _isTyping ? SizedBox(height: 10.0,)
            : Text(
              "Preparation",
              style: preparationTextStyle,
            ),
            _textField(),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  _textField() {
    var maxLines = 12;
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
        onTap: () => _onTextFieldTapped(),
      ),
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

  _openRecordingScreen() async{
   await Navigator.push(
      context, MaterialPageRoute(builder: (_) => RecordingScreen(noteText: _controller.text),),);
    FocusScope.of(context).requestFocus(FocusNode());
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

}
