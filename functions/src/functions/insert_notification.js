const admin = require('firebase-admin');
const _db = admin.firestore();
const uuid = require("uuid");

exports.insertNotification = async ({type, userId, groupId, postId, content}) => {
    const docId = uuid.v4();

    await _db.doc(`notifications/${docId}`).set(
        {
            "createdAt": Date.now(),
            "notificationType": type,
            "notificationId": docId,
            "userId": userId,
            "groupId": groupId,
            "postId": postId,
            "content": content,
        }
    );
    return docId;
}