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


    // --- insert 'photoUrl' and 'name' field to document on members sub-collection ---
    //make all the members
    //fetch user data of each member
    //add that info on member
    await _db.collection('groups').get().then((groupsSnap) => {
        groupsSnap.forEach((group) => {
            _db.collection(`groups/${group.id}/members`).get().then((membersSnap) => {
                membersSnap.forEach((member) => {
                    //fetch user info of each member
                    _db.doc(`users/${member.id}`).get().then((user) => {
                        const photoUrl = user.data().photoUrl;
                        const name = user.data().inAppUserName;
                        if (photoUrl != null && name != null) {
                            member.ref.update({
                                'photoUrl': photoUrl,
                                'name': name,
                            });
                        }
                    });

                });
            });

        });
    });


    res.send(`data is modified!!!`);


});
