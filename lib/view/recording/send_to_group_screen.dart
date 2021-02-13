import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/recording_view_model.dart';

class SendToGroupScreen extends StatefulWidget {
  final String path;
  final String audioDuration;

  SendToGroupScreen({@required this.audioDuration, @required this.path});
  @override
  _SendToGroupScreenState createState() => _SendToGroupScreenState();
}

class _SendToGroupScreenState extends State<SendToGroupScreen> {
  List<bool>  _chooseGroupButtonBooleans = List();

  @override
  Widget build(BuildContext context) {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    Future(() => recordingViewModel.getMyGroup());

    return Scaffold(
      appBar: AppBar(
        title: Text("Send to"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 16.0,),
            Selector<RecordingViewModel, Tuple2<List<Group>, bool>>(
              selector: (context, viewModel) => Tuple2(viewModel.groups, viewModel.isProcessing),
                builder: (context, data, child){
                  return data.item2
                      ? CircularProgressIndicator()
                      : _myGroupListView(data.item1);
                }),
            _doneButton(),
          ],
        ),
      ),
    );
  }

  Widget _myGroupListView(List<Group> groups) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: groups.length,
        itemBuilder: (context, int index){
          final group = groups[index];
          //todo when playing the audio independently on GroupScreen, check these comments, then erase them
          // for (var i = 0; i < model.groups.length; i++){
          //   _chooseGroupButtonBooleans.length = groups.length;
          //   _chooseGroupButtonBooleans[i] = false;
          // }
          // var isChooseGroupButtonPressed = _chooseGroupButtonBooleans[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(group.groupName),
                trailing: ChooseGroupButton(/*isChooseGroupButtonPressed: isChooseGroupButtonPressed,*/ groupId: group.groupId,),
              ),
            ),
          );
        });
  }


  //--------------------------------------------------------------------------------------------------- _doneButton()

 Widget _doneButton() {

   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 24.0),
     child: Container(
       width: double.infinity,
       child: Consumer<RecordingViewModel>(
         builder: (context, model, child){
           return RaisedButton(
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8.0)
               ),
               color: model.groupIds.isEmpty ? Colors.grey : Colors.lightBlue,
               child: Text("Done", style: model.groupIds.isEmpty ? buttonNotEnabledTextStyle : buttonEnabledTextStyle,),
               onPressed: () => model.groupIds.isEmpty ? null : _onDoneButtonPressed());
         },
       ),
     ),
   );





 }

  _onDoneButtonPressed() async{
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    await recordingViewModel.postRecording(widget.path, widget.audioDuration);

    //todo animation
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

  }


}

//--------------------------------------------------------------------------------------------------- ChooseGroupButton class

class ChooseGroupButton extends StatefulWidget {
  final bool isChooseGroupButtonPressed;
  final String groupId;
  ChooseGroupButton({this.groupId, this.isChooseGroupButtonPressed});

  @override
  _ChooseGroupButtonState createState() => _ChooseGroupButtonState();
}

class _ChooseGroupButtonState extends State<ChooseGroupButton> {
  bool _isChooseGroupButtonPressed = false;

  @override
  void initState() {
   // _isChooseGroupButtonPressed = widget.isChooseGroupButtonPressed;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isChooseGroupButtonPressed
        ? _undoButton()
        : _sendButton();

  }

  Widget _undoButton() {
    return RaisedButton(
        child: Text("Undo"),
        onPressed:() => _onUndoButtonPressed());
  }
  _onUndoButtonPressed() {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    recordingViewModel.removeGroupId(widget.groupId);

    setState(() {
      _isChooseGroupButtonPressed = false;
    });

  }


  Widget _sendButton() {
    return RaisedButton(
        child: Text("Send"),
        onPressed: () => _onSendButtonPressed());
  }

  _onSendButtonPressed() {
    final recordingViewModel = Provider.of<RecordingViewModel>(context, listen: false);
    recordingViewModel.addGroupId(widget.groupId);

    setState(() {
      _isChooseGroupButtonPressed = true;
    });

  }



}

