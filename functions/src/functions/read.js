const admin = require('firebase-admin');
const _db = admin.firestore();

exports.fetchGroupMemberIds = async ({groupId, userId}) => {
    let memberIds = [];

    await _db.collection(`groups/${groupId}/members`).get().then(
        (membersSnap) => {
            membersSnap.docs.map((member) => {
                if (userId == null) {
                    memberIds.push(member.id);
                } else {
                    if (member.id !== userId) {
                        //add members' ids only
                        memberIds.push(member.id);
                    }
                }
            });
        }
    );
    return memberIds;
}

exports.fetchGroupIdsByUser = async ({userId}) => {
    let groupIds = [];
    await _db.collection(`users/${userId}/groups`).get().then(
      (groupsSnap) => {
          groupsSnap.docs.map((group) => {
                  groupIds.push(group.id);
          });
      }
    );
    return groupIds;
}


