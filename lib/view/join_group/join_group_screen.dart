import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/view/join_group/group_detail_screen.dart';
import 'package:voice_put/view_models/join_group_view_model.dart';

class JoinGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinGroupViewModel = Provider.of<JoinGroupViewModel>(context, listen: false);
    Future(() => joinGroupViewModel.getGroupsExceptForMine());

    return Scaffold(
      appBar: AppBar(
        title: Text("Join a Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<JoinGroupViewModel>(builder: (context, model, child) {
          return model.isProcessing
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: model.groups.length,
              itemBuilder: (context, int index) {
                final group = model.groups[index];
                return Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () => _openGroupDetailScreen(context, group),
                    child: ListTile(
                      title: Text(group.groupName),
                      subtitle: Text(group.description, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  _openGroupDetailScreen(BuildContext context, Group group) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((_) => GroupDetailScreen(group: group)),
      ),
    );
  }
}
