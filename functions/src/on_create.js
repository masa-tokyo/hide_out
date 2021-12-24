const functions = require('firebase-functions').region('asia-northeast1');
const admin = require('firebase-admin');
const uuid = require("uuid");

const _db = admin.firestore();
const _auth = admin.auth();
const _storage = admin.storage();

exports.testHttps = functions.https.onRequest(async (req, res) => {
    console.log('testHttps starts');

    await _db.collection('triggers').add(
        {'message': 'hi'}
    );

    console.log('testHttps ends');

    res.send(`https function called!`);


});

exports.testMethod = functions.firestore.document('triggers/2/tests/{docId}').onCreate(
    async (snap, context) => {
        console.log('starts');
        // const id = snap.id;
        console.log('finished');
        return await _db.collection('triggers').add(
            {'message': 'added!!!'}
        );

        // return await _db.doc('triggers/2/tests/${docId}').update(
        //     {'isUpdated': true}
        // );
    }
);
exports.testMethod2 = functions.firestore.document('triggers/2/tests/{docId}').onCreate(
    async (snap, context) => {
        console.log('starts');
        // const id = snap.id;
        console.log('finished');
        return await _db.collection('triggers').add(
            {'message': 'added!!!'}
        );

        // return await _db.doc('triggers/2/tests/${docId}').update(
        //     {'isUpdated': true}
        // );
    }
);



    exports.deleteUserAccount = functions.firestore.document('triggers/1/deleted_users/{docId}').onCreate(
    async (snap, context) => {

        console.log('onCreated');
        await _db.doc(`triggers/1/deleted_users/${snap.id}`).update(
            {'amICool': true}
        );



        // //TODO(me): uncomment all
        // TODO (me): delete groups sub-collection under users collection
        //
        // const userId = snap.data().userId;
        //
        // //@members in groups
        //     let groupIds = [];
        //     await _db.collection(`users/${userId}/groups`).get().then(
        //         (value) =>{
        //             value.docs.forEach(
        //                 (group) => {
        //                     console.log(`group.data().groupId: ${group.data().groupId}`);
        //                     groupIds.push(group.data().groupId);
        //                 }
        //             );
        //         }
        //     );
        //     console.log(`groupIds: ${groupIds}`);
        //
        //     for (const groupId of groupIds) {
        //         const ownerId = await _db.doc(`groups/${groupId}`).get().then(
        //             (value) => {
        //                 console.log(`value.data().ownerId: ${value.data().ownerId}`);
        //                 return value.data().ownerId;
        //             }
        //         );
        //         console.log(`ownerId: ${ownerId}`);
        //
        //         //delete @members collection
        //         await _db.doc(`groups/${groupId}/members/${userId}`).delete();
        //
        //         //assign the oldest user to the owner, if the deleted user was the owner
        //         if(userId === ownerId){
        //             console.log(`The deletedUser was the owner of ${groupId}`);
        //
        //             await _db.collection(`groups/${groupId}/members`).get().then(
        //                 async (value) => {
        //
        //                     let theOldest;
        //                     for (let i = 0; i < value.docs.length; i++){
        //                         console.log(`i: ${i}`);
        //
        //                         if(value.docs.length > 1){
        //                             //repeat until the last member(located at i+1) is compared
        //                             if(i + 1 < value.docs.length){
        //                                 console.log(`value.docs[i].data().userId: ${value.docs[i].data().userId}`);
        //                                 console.log(`value.docs[i + 1].data().userId: ${value.docs[i + 1].data().userId}`);
        //
        //                                 if(value.docs[i].data().createdAt <= value.docs[i + 1].data().createdAt){
        //
        //                                     theOldest = value.docs[i].data();
        //                                     console.log(`comparison No.${i}: former is older`);
        //                                     console.log(`theOldest.userId: ${theOldest.userId}`);
        //
        //                                 } else {
        //                                     theOldest = value.docs[i++].data();
        //                                     console.log(`comparison No.${i}: latter is older`);
        //                                     console.log(`theOldest.userId: ${theOldest.userId}`);
        //                                 }
        //
        //                             }
        //                         } else {
        //                             // only one member
        //                             theOldest = value.docs[i].data();
        //                             console.log('the only member');
        //                         }
        //                     }
        //                     console.log(`comparison finished; theOldest.userId: ${theOldest.userId}`);
        //
        //                     const groupRef = await _db.doc(`groups/${groupId}`);
        //                     await groupRef.update(
        //                         {"ownerId": theOldest.userId}
        //                     );
        //
        //                     //insert notification to the new owner
        //                     const id = uuid.v4();
        //                     const groupName = await groupRef.get().then(
        //                         (value) =>{
        //                             return value.data().groupName;
        //                     }
        //                     );
        //                     await _db.doc(`notifications/${id}`).set(
        //                         {
        //                             "createdAt": Date.now(),
        //                             "notificationType": "NEW_OWNER",
        //                             "notificationId": id,
        //                             "userId": theOldest.userId,
        //                             "groupId": groupId,
        //                             "postId": "",
        //                             "content": groupName,
        //                         }
        //                     )
        //                 }
        //             );
        //
        //         }
        //     }
        //
        //
        // //@posts
        // //     await _db.collection('posts').where('userId', '==', userId).get().then(
        // //         (value) => {
        // //             value.docs.forEach(
        // //                 async (element) => {
        // //                     let post = element.data();
        // //                     //delete post audio@storage
        // //                     let audioStoragePath = post.audioStoragePath;
        // //                     console.log(`audioStoragePath: ${audioStoragePath}`);
        // //                     await _storage.bucket().file(audioStoragePath).delete();
        // //                     //delete post
        // //                     await element.ref.delete();
        // //                 }
        // //             )
        // //         }
        // //     )
        //
        // //@users
        //
        //     //delete self-intro & profile pictures @storage
        //     const user = await _db.doc(`users/${userId}`).get();
        //
        //     //TODO: check whether actually deleted or not
        //     const audioStoragePath = user.data().audioStoragePath;
        //
        //     if(audioStoragePath !== '') {
        //         await _storage.bucket().file(audioStoragePath).delete();
        //     }
        //
        //     const photoStoragePath = user.data().photoStoragePath;
        //     if (photoStoragePath !== '') {
        //         await _storage.bucket().file(photoStoragePath).delete();
        //     }
        //
        //     //delete user
        //     await _db.doc(`users/${userId}`).delete();
        //
        //     //delete @Authentication
        //     await _auth.deleteUser(userId);
        //     console.log(`${userId} is deleted`);
        //
        //
        //
        // //store the deleteUsers in the triggers collection
        // await _db.doc(`triggers/1/deleted_users/${snap.id}`).update(
        //     {'isDeleted': true}
        // );


    }
);