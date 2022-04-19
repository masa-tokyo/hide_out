const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const _db = admin.firestore();
const {updateLastActivityAt} = require("./functions/update_last_activity_at");
const {insertNotification} = require("./functions/insert_notification");
const {deleteUserAccount} = require("./functions/delete_user_account");
const {fetchGroupMemberIds} = require("./functions/read");


exports.onPostCreated = functions.firestore.document('posts/{postId}').onCreate(
  async (snap) => {

    const groupsPromise = updateLastActivityAt(snap);

    const userIds = await fetchGroupMemberIds({
      groupId: snap.data().groupId,
      userId: snap.data().userId
    });
    const notificationsPromises = userIds.map((userId) => {
      return insertNotification(
        {
          type: 'NEW_POST',
          userId: userId,
          groupId: snap.data().groupId,
          postId: snap.data().postId,
          content: snap.data().title
        });
    });

    await Promise.all([groupsPromise, notificationsPromises]);

  }
);

exports.onMemberCreated = functions.firestore
  .document('groups/{groupId}/members/{userId}')
  .onCreate(async (snap, context) => {
    const userId = snap.id;
    const userName = snap.data().name;
    const photoUrl = snap.data().photoUrl;
    const groupId = context.params.groupId;

    //update memberNames on groups
    await _db.doc(`groups/${groupId}`).get().then((groupSnap) => {
      const members = groupSnap.data().members;
      members.push({
        'userId': userId,
        'name': userName,
        'photoUrl': photoUrl,
      });
      groupSnap.ref.update({
        'members': members
      });
    });
  });

exports.onListenerCreated = functions.firestore
  .document('posts/{postId}/listeners/{userId}').onCreate(
    async (snap, context) => {
      const postId = context.params.postId;
        _db.doc(`posts/${postId}`).update({
          'isListened': true
        });

    });


exports.onDeleteAccountTriggered = functions.firestore.document('triggers/{userId}/delete_account/{docId}')
  .onCreate(async (snap) => {
      await deleteUserAccount(snap);

    }
  );