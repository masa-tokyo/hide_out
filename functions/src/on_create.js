const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const {updateLastActivityAt} = require("./functions/update_last_activity_at");
const {insertNotification} = require("./functions/insert_notification");
const {deleteUserAccount} = require("./functions/delete_user_account");
const {fetchGroupMemberIds} = require("./functions/read");


exports.onPostCreated = functions.firestore.document('posts/{postId}').onCreate(
    async (snap) => {

        const groupsPromise = updateLastActivityAt(snap);

        const userIds = await fetchGroupMemberIds({
            groupId: snap.data().groupId,
            userId: snap.data().userId});
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


exports.onDeleteAccountTriggered = functions.firestore.document('triggers/{userId}/delete_account/{docId}')
    .onCreate(async (snap) => {
            await deleteUserAccount(snap);

        }
    );