const admin = require('firebase-admin');
const {fetchGroupIdsByUser} = require("./read");
const _db = admin.firestore();

exports.updateUserName = async ({userId, userName}) => {

  //update name on members
  const groupIds = await fetchGroupIdsByUser({userId});

  groupIds.map((groupId) => {
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
