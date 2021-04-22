import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/common/items/dialog/help_dialog.dart';
import 'package:voice_put/view/group/group_screen.dart';
import 'package:voice_put/utils/style.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';

class MyGroupPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    Future(() => homeScreenViewModel.getMyGroup());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            "My Group",
            style: homeScreenLabelTextStyle,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Selector<HomeScreenViewModel, Tuple4<bool, List<Group>, List<Group>, List<String>>>(
          selector: (context, viewModel) => Tuple4(viewModel.isProcessing, viewModel.autoExitGroups, viewModel.groups, viewModel.closedGroupNames),
          builder: (context, data, child) {
            if (data.item1) {
              return Center(child: CircularProgressIndicator());

            } else {
              _showAutoExitDialog(context, data.item2);
              _showClosedGroupNameDialog(context, data.item4);
              return data.item3.isEmpty ? _newGroupIntro() : _myGroupListView(data.item3);
            }
          },
        ),
      ],
    );
  }

  _openGroupScreen(BuildContext context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupScreen(group: group),
      ),
    );
  }

  Widget _newGroupIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: textFieldFillColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              "*Join/Start Group below",
              style: newGroupIntroTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showAutoExitDialog(BuildContext context, List<Group> autoExitGroups) async {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    if (autoExitGroups.isNotEmpty) {
      autoExitGroups.forEach((autoExitGroup) {
        Future(() => showHelpDialog(
            context: context,
            title: Text("Auto-Exit Period"),
            contentString:
            'You have exited from "${autoExitGroup.groupName}". Please enter again if you want.',
            okayString: "Okay",
            onConfirmed: (){
              homeScreenViewModel.deleteAutoExitGroup(autoExitGroup);
            }));
      });
    }
  }

  void _showClosedGroupNameDialog(BuildContext context, List<String> closedGroupNames) async {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    if (closedGroupNames.isNotEmpty) {
      closedGroupNames.forEach((groupName) {
        Future(() => showHelpDialog(
            context: context,
            title: Text("We are sorry!"),
            contentString:
            'Your group,"$groupName" was closed by the group owner.',
            okayString: "Okay",
            onConfirmed: (){
              homeScreenViewModel.deleteClosedGroupName(groupName);

            }));
      });
    }
  }


  Widget _myGroupListView(List<Group> groups) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: groups.length,
        itemBuilder: (context, int index) {
          final group = groups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: listTileColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2.0,
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () => _openGroupScreen(context, group),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      group.groupName,
                      style: listTileTitleTextStyle,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  dense: true,
                ),
              ),
            ),
          );
        });
  }
}
