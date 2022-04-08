const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const uuid = require("uuid");

const _db = admin.firestore();
const _storage = admin.storage();



exports.testFunction = functions.https.onRequest(async (req, res) => {

    const userId = req.query.userId;




});


exports.modifyDb = functions.https.onRequest(async (req, res) => {
// STEP1: write any action to modify firestore database
// STEP2: Acquire a url after the deployment
// STEP3: Call the function by copying and pasting the url in a browser


    // --- delete docs at notifications ---
    // const notifications = await _db.collection("notifications").get();
    // if (notifications.docs.length === 0) return;
    //
    //
    // for (const notification of notifications.docs) {
    //
    //     if(notification.data().notificationType === "ALERT_AUTO_EXIT"){
    //
    //         await notification.ref.delete();
    //     }
    // }


    // --- insert "createdAt" field to document on members sub-collection ---
    // await _db.collection(`groups`).get().then(
    //     (groups) => {
    //         groups.docs.forEach(async (group) =>
    //         {
    //             await _db.collection(`groups/${group.data().groupId}/members`).get().then(
    //                 (members) => {
    //                     members.docs.forEach(
    //                         async (member) => {
    //                             await _db.doc(`groups/${group.data().groupId}/members/${member.data().userId}`)
    //                                 .update({"createdAt": Date.now()}
    //                             )
    //                         }
    //                     )
    //                 }
    //             )
    //         })
    //     }
    //
    // )


    res.send(`data is modified!!!`);


});
