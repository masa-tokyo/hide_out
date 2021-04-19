import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view/common/dialog/help_dialog.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

class AutoExitPeriodPart extends StatefulWidget {
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

  int _intDays = 0;

  @override
  void initState() {
    super.initState();
    _intDays = _itemList[1].value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _text(),
              _helpIcon(),
            ],
          ),
          _button(),
        ],
      ),
    );
  }

  Widget _text() {
    return Text(
      "Auto-Exit Period",
      style: startGroupLabelTextStyle,
    );
  }

  Widget _helpIcon() {
    return IconButton(
        icon: Icon(Icons.help_outline),
        tooltip: "Members will be kicked out of the group after certain period of time.",
        onPressed: () => showHelpDialog(
              context: context,
              contentString: "Members will be kicked out of the group after certain period of time.",
              okayString: "Okay",
            ));
  }

  Widget _button() {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: autoExitButtonColor),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: _itemList,
          value: _intDays,
          onChanged: (selectedValue) {
            setState(() {
              _intDays = selectedValue;
            });
            startGroupViewModel.updateAutoExitPeriod(_intDays);
          },
          dropdownColor: autoExitButtonColor,
        ),
      ),
    );
  }
}
