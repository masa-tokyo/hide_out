const admin = require('firebase-admin');
const {fetchGroupIdsByUser} = require("./read");
const _db = admin.firestore();

exports.updateUserName = async ({userId, userName}) => {

  const groupIds = await fetchGroupIdsByUser({userId});

  groupIds.map((groupId) => {
    //update name on groups
    _db.doc(`groups/${groupId}`).get().then((group) => {
      const members = group.data().members;
      const targetIndex = members.findIndex((member) => member.userId === userId);
      const photoUrl = members[targetIndex].photoUrl;
      members[targetIndex] = {
        'userId': userId,
        'name': userName,
        'photoUrl': photoUrl,
      };
      group.ref.update({
        'members': members
      });
    });

    //update name on members
    _db.doc(`groups/${groupId}/members/${userId}`).update({
      'name': userName
    });
  });



  //update userName on posts
  _db.collection('posts').where('userId', '=', userId).get().then((postsSnap) => {
    postsSnap.docs.map((post) => {
      post.ref.update({
        'userName': userName
      });
    });
  });

  //update userName on listeners
  groupIds.map((groupId) => {
    _db.collection('posts').where('groupId', '=', groupId).get().then((postsSnap) => {
      postsSnap.docs.map((post) => {
        _db.collection(`posts/${post.id}/listeners`).get().then((listenersSnap) => {
          listenersSnap.docs.map((listener) => {
            if(listener.id === userId) {
              listener.ref.update({
                'userName': userName
              });
            }
          });
        });

      });
    });

  });

}
