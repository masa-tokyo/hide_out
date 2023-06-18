const admin = require('firebase-admin');
const {fetchGroupIdsByUser} = require("./read");
const _db = admin.firestore();

exports.updateAudioUrl = async ({userId, audioUrl}) => {

  //update url on members
  const groupIds = await fetchGroupIdsByUser({userId});

  groupIds.map(async (groupId) => {
    _db.doc(`groups/${groupId}/members/${userId}`).update({
      'audioUrl': audioUrl
    });

  });

}