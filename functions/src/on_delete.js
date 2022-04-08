const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');

const _db = admin.firestore();


exports.deletePostNotifications = functions.firestore.document('posts/{postId}').onDelete(
    async (snapshot) => {

        const postId = snapshot.data().postId;

        await _db.collection('notifications').where('postId', '==', postId).get().then(
            (value) => {
                value.docs.map((notification) => {
                    notification.ref.delete();
                });
            }
        );
    }
);