import 'package:flutter/material.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/utils/style.dart';
import 'package:hide_out/view/profile/profile_screen.dart';

class MembersList extends StatelessWidget {
  const MembersList(
      {Key? key,
      required this.currentUserId,
      required this.group})
      : super(key: key);

  final String currentUserId;
  final Group group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Member",
                style: groupDetailLabelTextStyle,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "(${group.members.length} / 5)",
                style: groupDetailLabelTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          group.members.isEmpty
              ? Text(
                  "-No Member-",
                )
              : Container(
                  decoration: BoxDecoration(
                    color: listTileColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                      itemCount: group.members.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int index) {
                        final member = group.members[index];
                        return ListTile(
                          onTap: () => _openProfileScreen(
                              context, currentUserId, member.userId),
                          title: Text(
                            member.name,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20.0,
                          ),
                        );
                      }),
                ),
        ],
      ),
    );
  }

  _openProfileScreen(
      BuildContext context, String currentUserId, String memberId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfileScreen(
                  memberId: currentUserId == memberId ? null : memberId,
                  groupId: currentUserId == memberId ? null : group.groupId,
                )));
  }
}
