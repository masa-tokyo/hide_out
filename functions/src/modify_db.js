
const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const _db = admin.firestore();

exports.modifyDb = functions.https.onRequest(async (req, res) => {
// STEP1: write any action to modify firestore database
// STEP2: Acquire a url after the deployment
// STEP3: Call the function by copying and pasting the url in a browser


    const notifications = await _db.collection("notifications").get();
    if (notifications.docs.length === 0) return;


    for (const notification of notifications.docs) {

        if(notification.data().notificationType === "ALERT_AUTO_EXIT"){

            await notification.ref.delete();
        }
    }

    res.send(`data is modified`);


});
