const admin = require('firebase-admin');
const {fetchGroupIdsByUser} = require("./read");
const _db = admin.firestore();

exports.updatePhotoUrl = async ({userId, photoUrl}) => {

  //update url on members
  const groupIds = await fetchGroupIdsByUser({userId});

  groupIds.map(async (groupId) => {
    _db.doc(`groups/${groupId}/members/${userId}`).update({
      'photoUrl': photoUrl
    });

    //update url on groups
    const groupRef = _db.doc(`groups/${groupId}`);
    const group = await groupRef.get();
    const members = group.data().members;
    const targetIndex = members.findIndex((member) => member.userId === userId);
    const userName = members[targetIndex].name;
    members[targetIndex] = {
      'userId': userId,
      'name': userName,
      'photoUrl': photoUrl,
    };
    groupRef.update({
      'members': members
    });

    //if owner, update url on ownerPhotoUrl on groups
    if(group.data().ownerId === userId) {
      groupRef.update({
        'ownerPhotoUrl': photoUrl
      });
    }
  });

}