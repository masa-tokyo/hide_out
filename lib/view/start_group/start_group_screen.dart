import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:voice_put/view/start_group/components/about_group_part.dart';
import 'package:voice_put/view/common/components/auto_exit_period_part.dart';
import 'package:voice_put/view/start_group/components/group_name_part.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/start_group_view_model.dart';

class StartGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start New Group"),
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


        //todo delete Consumer
        // child: Consumer<StartGroupViewModel>(
        //   builder: (context, model, child) {
        //     return model.isProcessing
        //         ? Center(
        //             child: CircularProgressIndicator(),
        //           )
        //         : Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               GroupNamePart(),
        //               AutoExitPeriodPart(
        //                 isBeginningGroup: true,
        //               ),
        //               AboutGroupPart(),
        //               SizedBox(
        //                 height: 12.0,
        //               ),
        //               _doneButton(context),
        //             ],
        //           );
        //   },
        // ),

        //todo delete Selector
        // child:
        // Selector<StartGroupViewModel, Tuple3<bool, String, String>>(
        //   selector: (context, viewModel) =>
        //       Tuple3(viewModel.isProcessing, viewModel.groupName, viewModel.description),
        //   builder: (context, data, child) {
        //     return data.item1
        //         ? Center(child: CircularProgressIndicator(),)
        //         : Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         GroupNamePart(),
        //         AutoExitPeriodPart(isBeginningGroup: true,),
        //         AboutGroupPart(),
        //         SizedBox(
        //           height: 12.0,
        //         ),
        //         _doneButton(context),
        //       ],
        //     );
        //   },
        // )
        // ,
      ),
    );
  }

  Widget _doneButton(BuildContext context) {
    return Consumer<StartGroupViewModel>(
      builder: (context, model, child) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: model.groupName != "" && model.description != ""
                      ? MaterialStateProperty.all<Color>(buttonEnabledColor)
                      : MaterialStateProperty.all<Color>(buttonNotEnabledColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                onPressed: (model.groupName != "" && model.description != "")
                    ? () => _registerGroup(context)
                    : null,
                child: Text(
                  "Done",
                  style: enabledButtonTextStyle,
                ),
              ),
            ));
      },
    );
  }

  _registerGroup(BuildContext context) async {
    final startGroupViewModel = Provider.of<StartGroupViewModel>(context, listen: false);
    await startGroupViewModel.registerGroup();

    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Done!", gravity: ToastGravity.CENTER);
  }
}
