const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const {updateUserName} = require("./functions/update_user_name");
const {updatePhotoUrl} = require("./functions/update_photo_url");


exports.onUserUpdated = functions.firestore.document('users/{userId}').onUpdate(
  async (snap) => {

    const userId = snap.after.id;

    //if name is updated:
    if (snap.before.data().inAppUserName !== snap.after.data().inAppUserName) {
      await updateUserName({
        userId,
        userName: snap.after.data().inAppUserName
      });
    }

    //if photoUrl is updated:
    if (snap.before.data().photoUrl !== snap.after.data().photoUrl) {
      await updatePhotoUrl({
        userId,
        photoUrl: snap.after.data().photoUrl});
    }
  }
);