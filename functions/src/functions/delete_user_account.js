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
        //delete @members collection
        await _db.doc(`groups/${groupId}/members/${userId}`).delete();

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