import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:hide_out/view/start_group/components/about_group_part.dart';
import 'package:hide_out/view/common/components/auto_exit_period_part.dart';
import 'package:hide_out/view/start_group/components/group_name_part.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view_models/start_group_view_model.dart';

class StartGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start a Group"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupNamePart(),
            SizedBox(height: 16.0,),
            AutoExitPeriodPart(
              isBeginningGroup: true,
            ),
            SizedBox(height: 16.0,),
            AboutGroupPart(),
            SizedBox(height: 32.0,),
            _doneButton(context),
          ],
        ),
      ),
    );
  }

  Widget _doneButton(BuildContext context) {
    return Consumer<StartGroupViewModel>(
      builder: (context, model, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: model.groupName != ""
                  && model.description != ""
                  && model.isFirstTap
                  ? MaterialStateProperty.all<Color>(buttonEnabledColor)
                  : MaterialStateProperty.all<Color?>(buttonNotEnabledColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            onPressed: (model.groupName != ""
                && model.description != ""
                && model.isFirstTap
            )
                ? () => _createGroup(context)
                : null,
            child: Text(
              "Done",
              style: enabledButtonTextStyle,
            ),
          ),
        );
      },
    );
  }

  _createGroup(BuildContext context) async {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    startGroupViewModel.updateIsFirstTap();

    await startGroupViewModel.createGroup();

    Navigator.pop(context);

    startGroupViewModel.updateGroupName("");
    startGroupViewModel.updateDescription("");
    startGroupViewModel.updateIsFirstTap();

    Fluttertoast.showToast(msg: "Done!", gravity: ToastGravity.CENTER);
  }
}
