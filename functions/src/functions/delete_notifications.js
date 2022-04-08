const admin = require('firebase-admin');
const _db = admin.firestore();

exports.deleteNotifications = async ({userId, groupId, postId}) => {

if(groupId != null){
    if(userId != null){
        //delete notifications of a member in the group
        await _db.collection('notifications')
            .where('userId', '=', userId)
            .where('groupId', '=', groupId)
            .get().then((notificationsSnap) => {
                notificationsSnap.docs.map((notification) => {
                    notification.ref.delete();
                });
            });
    } else {
        //delete all the notifications of the group
        await _db.collection('notifications')
            .where('groupId', '=', groupId)
            .get().then((notificationsSnap) => {
                notificationsSnap.docs.map((notification) => {
                    notification.ref.delete();
                });
            });
    }
}

    if(postId != null){
        //delete notifications of a post
        await _db.collection('notifications')
            .where('postId', '=', postId)
            .get().then((notificationsSnap) => {
                notificationsSnap.docs.map((notification) => {
                    notification.ref.delete();
                });
            });
    }

}