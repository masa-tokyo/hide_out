import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/common/items/help_icon.dart';
import 'package:hide_out/view_models/group_view_model.dart';
import 'package:hide_out/view_models/start_group_view_model.dart';

class AutoExitPeriodPart extends StatefulWidget {
  final bool isBeginningGroup;
  final Group? group;

  AutoExitPeriodPart({required this.isBeginningGroup, this.group});

  @override
  _AutoExitPeriodPartState createState() => _AutoExitPeriodPartState();
}

class _AutoExitPeriodPartState extends State<AutoExitPeriodPart> {
  final List<DropdownMenuItem<int>> _itemList = [
    DropdownMenuItem(value: 2, child: Text("2 Days")),
    DropdownMenuItem(value: 4, child: Text("4 Days")),
    DropdownMenuItem(value: 7, child: Text("7 Days")),
    DropdownMenuItem(value: 15, child: Text("15 Days"))
  ];

  int? _intDays = 0;


  @override
  void initState() {
    super.initState();
    _setInitialValue();
  }

  void _setInitialValue() {
    if(widget.isBeginningGroup) {
      _intDays = _itemList[1].value;
    } else {
      _intDays = widget.group!.autoExitDays;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _text(),
            HelpIcon(message: "Members will be kicked out of the group after certain period of time."),
          ],
        ),
        _button(),
      ],
    );
  }

  Widget _text() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Text(
        "Auto-Exit Period",
        style: startGroupLabelTextStyle,
      ),
    );
  }

  Widget _button() {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: autoExitButtonColor),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            items: _itemList,
            value: _intDays,
            onChanged: (dynamic selectedValue) {
              setState(() {
                _intDays = selectedValue;
              });
              if(widget.isBeginningGroup){
                startGroupViewModel.updateAutoExitPeriod(_intDays);
              } else {
                groupViewModel.updateAutoExitPeriod(_intDays);
              }
              },
            dropdownColor: autoExitButtonColor,
          ),
        ),
      ),
    );
  }

}
