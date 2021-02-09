import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
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
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            "My Group",
            style: homeScreenLabelTextStyle,
          ),
        ),
        SizedBox(height: 8.0,),
        Consumer<HomeScreenViewModel>(
          builder: (context, model, child) {
            return model.isProcessing
              ? Center(child: CircularProgressIndicator(),)
              : model.groups.isEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                  width: double.infinity,
                  child: Text("Join or Start a Group!")),
                )
                : ListView.builder(
                shrinkWrap: true,
                itemCount: model.groups.length,
                itemBuilder: (context, int index) {
                  final group = model.groups[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2.0,
                        child: InkWell(
                          splashColor: Colors.blueGrey,
                          onTap: () => _openGroupScreen(context, group),
                          child: ListTile(
                            title: Text(group.groupName, style: listTileTitleTextStyle,),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            dense: true,
                          ),
                        ),
                      ),
                    );
                });
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
}
