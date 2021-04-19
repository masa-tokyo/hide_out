import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/common/dialog/help_dialog.dart';
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
        Consumer<HomeScreenViewModel>(
          builder: (context, model, child) {
            if (model.isProcessing) {
              return Center(
                  child: CircularProgressIndicator());
            } else {
              if (model.groups.isEmpty) {
                return _newGroupIntro();
              } else {

                _showDialog(context, model);

                return _myGroupListView(model);
              }
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
              "↓ Join/Start a Group",
              style: newGroupIntroTextStyle,
              textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, HomeScreenViewModel model) async{

    //todo [check] why pop up several times even when isProcessing is true

    if(model.deletedGroups.isNotEmpty){
      model.deletedGroups.forEach((
          deletedGroup) {
        Future(() =>
            showHelpDialog(
                context: context,
                contentString: 'You have existed from "${deletedGroup.groupName}". Please enter again if you want.',
                okayString: "Okay"));
      });

      //todo [check] if it does not work, change it to Future.forEach
      // await Future.forEach(model.deletedGroups, (deletedGroup) {
      //   Future(() =>
      //       showHelpDialog(
      //           context: context,
      //           contentString: 'You have existed from "${deletedGroup.groupName}". Please enter again if you want.',
      //           okayString: "Okay"));
      // });


    }


  }


  Widget _myGroupListView(HomeScreenViewModel model) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: model.groups.length,
        itemBuilder: (context, int index) {
          final group = model.groups[index];
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
