const admin = require('firebase-admin');
const _db = admin.firestore();

exports.updateLastActivityAt = async (snap) => {

    const groupId = snap.data().groupId;
    await _db.doc(`groups/${groupId}`).update({
        lastActivityAt: Date.now()
    });
}
