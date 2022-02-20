const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const uuid = require("uuid");
const {updateLastActivityAt} = require("./functions/update_last_activity_at");
const {insertNotification} = require("./functions/insert_notification");
const {deleteUserAccount} = require("./functions/delete_user_account");

const _db = admin.firestore();


exports.onPostCreated = functions.firestore.document('posts/{postId}').onCreate(
    async (snap) => {

        const groupsPromise = updateLastActivityAt(snap);

        const userIds = await fetchGroupMemberIds(snap.data().groupId, snap.data().userId);
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

        async function fetchGroupMemberIds(groupId, userId) {
            let memberIds = [];

            await _db.collection(`groups/${groupId}/members`).get().then(
                (membersSnap) => {
                    membersSnap.docs.map((member) => {
                        //add members' ids only
                        if(member.id !== userId){
                            memberIds.push(member.id);
                        }
                    });
                }
            );
            return memberIds;
        }
    }
);


exports.onDeleteAccountTriggered = functions.firestore.document('triggers/{userId}/delete_account/{docId}')
    .onCreate(async (snap) => {
        await deleteUserAccount(snap);

        }
    );