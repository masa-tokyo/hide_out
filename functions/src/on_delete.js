const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const {fetchGroupMemberIds} = require("./functions/read");
const {insertNotification} = require("./functions/insert_notification");
const {deleteNotifications} = require("./functions/delete_notifications");

const _db = admin.firestore();
const _storage = admin.storage();

exports.onPostDeleted = functions.firestore.document('posts/{postId}').onDelete(
    async (snapshot) => {

        const postId = snapshot.id;

        await _db.collection('notifications').where('postId', '==', postId).get().then(
            (value) => {
                value.docs.map((notification) => {
                    notification.ref.delete();
                });
            }
        );
    }
);


exports.onGroupDeleted = functions.firestore.document('groups/{groupId}').onDelete(
    async (snapshot) => {
        const groupId = snapshot.id;

        // fetch all the userIds of the members
        const memberIds = await fetchGroupMemberIds({groupId: groupId});


        memberIds.map(
            (memberId) => {
                //delete posts
                _db.collection('posts')
                    .where('userId', '=', memberId)
                    .where('groupId', '=', groupId)
                    .get().then((postsSnap) => {
                    postsSnap.docs.map((post) => {
                        //on listeners
                        _db.collection('posts')
                            .doc(post.id)
                            .collection('listeners').get()
                            .then((listenersSnap) => {
                                listenersSnap.docs.map((listener) => {
                                    listener.ref.delete();
                                });
                            });
                        //on posts
                        post.ref.delete();

                        //on storage
                        _storage.bucket().file(post.data().audioStoragePath).delete();
                    });
                });
                // delete groups/members
                _db.doc(`groups/${groupId}/members/${memberId}`).delete();
                //delete users/groups
                _db.doc(`users/${memberId}/groups/${groupId}`).delete();
            }
        );

        // insert notifications for group members except for the owner
        const ownerId = snapshot.data().ownerId;
        const groupName = snapshot.data().groupName;

        // get ids of only members
        const memberOnlyIds = memberIds.filter((memberId) => memberId !== ownerId);

        memberOnlyIds.map((memberId) =>
            insertNotification(
                {
                    type: 'DELETED_GROUP',
                    userId: memberId,
                    //do not insert groupId as it would be deleted by deleteNotification
                    groupId: '',
                    postId: '',
                    content: groupName,
                }
            )
        );

        /*
        delete notifications
        */
         await deleteNotifications({
            groupId: groupId
        });

    }
);

//when a user leaves or deletes a group, is kicked out, or deleted an account
exports.onMemberDeleted = functions.firestore.document('groups/{groupId}/members/{memberId}')
    .onDelete(async (snapshot, context) => {
        
        const userId = snapshot.id;
        const groupId = context.params.groupId;

        const groupRef = _db.doc(`groups/${groupId}`);
        const groupSnap = await _db.doc(`groups/${groupId}`).get();

        if(!groupSnap.data()){
            //if the group is already deleted, there is nothing to do
            return;
        }

        // delete all the notifications for that member
        await deleteNotifications({
            userId: userId,
            groupId: groupId,
        });


        const ownerId = groupSnap.data().ownerId;
        //assign the oldest user to the owner, if the deleted user was the owner
        if (userId === ownerId) {

            await _db.collection(`groups/${groupId}/members`).get().then(
                async (value) => {

                    if(value.docs.length === 0) {
                        await groupRef.update(
                            {'ownerId': null,
                                'ownerPhotoUrl': null}
                        );
                    } else {
                        //assign the oldest member as the owner
                        let newOwner;
                        for (let i = 0; i < value.docs.length; i++) {
                            if (value.docs.length > 1) {
                                //repeat until the last member(located at i+1) is compared
                                if (i + 1 < value.docs.length) {
                                    if (value.docs[i].data().createdAt <= value.docs[i + 1].data().createdAt) {
                                        newOwner = value.docs[i];
                                    } else {
                                        newOwner = value.docs[i + 1];
                                    }
                                }
                            } else {
                                // only one member
                                newOwner = value.docs[i];
                            }
                        }

                        //update the owner info
                        await groupRef.update(
                            {'ownerId': newOwner.id,
                                'ownerPhotoUrl': newOwner.data().photoUrl}
                        );

                        //insert notification to the new owner
                        const groupName = await groupRef.get().then(
                            (value) => {
                                return value.data().groupName;
                            }
                        );
                        await insertNotification(
                            {
                                type: 'NEW_OWNER',
                                userId: newOwner.id,
                                groupId: groupId,
                                postId: '',
                                content: groupName,
                            }
                        );

                    }

                }
            );

        }

    });