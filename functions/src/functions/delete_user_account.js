const admin = require('firebase-admin');
const uuid = require("uuid");
const {insertNotification} = require("./insert_notification");

const _db = admin.firestore();
const _auth = admin.auth();
const _storage = admin.storage();

exports.deleteUserAccount = async (snap) => {


    const userId = snap.data().userId;

    //delete @Authentication
    await _auth.deleteUser(userId);


    //collect groupIds
    let groupIds = [];
    await _db.collection(`users/${userId}/groups`).get().then(
        (value) => {
            value.docs.forEach(
                (group) => {
                    groupIds.push(group.data().groupId);
                }
            );
        }
    );
    
    const posts = await _db.collection('posts').where('userId', '==', userId).get();

    
    // @users
    const usersPromise = deleteUser();

    // @groups
    const groupPromises = groupIds.map((groupId) => deleteMember(groupId));


    // @listeners of group members' posts
    const listenerPromises = groupIds.map((groupId) => deleteListener(groupId));
    
    // @posts
    const postPromises = posts.docs.map((post) => deletePost(post));

    // @notifications of currentUser
    const notificationsPromise = deleteNotifications({idName: 'userId', id: userId});


    await Promise.all([usersPromise, groupPromises, listenerPromises, postPromises, notificationsPromise]);

    //store the deleteUsers in the triggers collection
    await _db.doc(`triggers/${userId}/delete_account/${snap.id}`).update(
        {'isDeleted': true}
    );



    //----------------------------------------------------------------------Methods

    async function deleteUser() {
        //delete self-intro & profile pictures @storage
        const user = await _db.doc(`users/${userId}`).get();

        const audioStoragePath = user.data().audioStoragePath;

        if (audioStoragePath !== '') {
            _storage.bucket().file(audioStoragePath).delete();
        }

        const photoStoragePath = user.data().photoStoragePath;
        if (photoStoragePath !== '') {
            _storage.bucket().file(photoStoragePath).delete();
        }

        _db.collection(`users/${userId}/groups`).get().then(
            (groups) => {
                if (groups != null) {
                    groups.docs.map(
                        (group) => {
                            group.ref.delete();
                        }
                    );
                }
            }
        );

        //delete user
        _db.doc(`users/${userId}`).delete();

    }

    async function deleteMember(groupId) {
        // *since assigning a new owner is important, async is used quite often

        const ownerId = await _db.doc(`groups/${groupId}`).get().then(
            (value) => {
                return value.data().ownerId;
            }
        );

        //delete @members collection
        await _db.doc(`groups/${groupId}/members/${userId}`).delete();

        //assign the oldest user to the owner, if the deleted user was the owner
        if (userId === ownerId) {

            await _db.collection(`groups/${groupId}/members`).get().then(
                async (value) => {
                    let theOldest;
                    for (let i = 0; i < value.docs.length; i++) {
                        if (value.docs.length > 1) {
                            //repeat until the last member(located at i+1) is compared
                            if (i + 1 < value.docs.length) {
                                if (value.docs[i].data().createdAt <= value.docs[i + 1].data().createdAt) {
                                    theOldest = value.docs[i].data();
                                } else {
                                    theOldest = value.docs[i + 1].data();
                                }
                            }
                        } else {
                            // only one member
                            theOldest = value.docs[i].data();
                        }
                    }

                    const groupRef = _db.doc(`groups/${groupId}`);
                    await groupRef.update(
                        {"ownerId": theOldest.userId}
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
                            userId: theOldest.userId,
                            groupId: groupId,
                            postId: '',
                            content: groupName,
                        }
                    );
                }
            );

        }


    }

    async function deleteListener(groupId) {

        //delete myself on listeners of group members' posts
        _db.collection('posts')
            .where('groupId', '==', groupId).get()
            .then((posts) => {
                posts.docs.map((post) => {
                    _db.collection(`posts/${post.id}/listeners`)
                        .where('userId', '==', userId).get().then(
                        (listeners) => {
                            if (listeners != null) {
                                listeners.docs.map(
                                    (listener) => {
                                        listener.ref.delete();
                                    }
                                )
                            }
                        }
                    );
                });
            });

    }

   async function deletePost(post) {
        //@listeners
       _db.collection(`posts/${post.id}/listeners`).get().then(
           (listeners) => {
               if (listeners != null) {
                   listeners.docs.map(
                       (listener) => {
                           listener.ref.delete();
                       }
                   );
               }
           }
       );
        
       //delete post audio@storage
       const audioStoragePath = post.data().audioStoragePath;
       _storage.bucket().file(audioStoragePath).delete();
       //delete post itself
       post.ref.delete();
        
    }

    async function deleteNotifications({idName, id}) {
        await _db.collection('notifications').where(idName, '==', id).get().then(
            (value) => {
                value.docs.map((notification) => {
                    notification.ref.delete();
                });
            }
        );

    }

}