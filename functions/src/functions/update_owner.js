const admin = require('firebase-admin');
const _db = admin.firestore();
const {insertNotification} = require("./insert_notification");


exports.updateOwner = async ({groupId}) => {

  const groupRef = _db.doc(`groups/${groupId}`);
console.log('try to fetch members');
  await _db.collection(`groups/${groupId}/members`).get().then(
    async (value) => {

      if(value.docs.length === 0) {
        await groupRef.update(
          {'ownerId': null,
            'ownerPhotoUrl': null}
        );
      } else {
        //assign the oldest member as the owner
        let newOwner;
        for (let i = 0; i < value.docs.length; i++) {
          if (value.docs.length > 1) {
            //repeat until the last member(located at i+1) is compared
            if (i + 1 < value.docs.length) {
              if (value.docs[i].data().createdAt <= value.docs[i + 1].data().createdAt) {
                newOwner = value.docs[i];
              } else {
                newOwner = value.docs[i + 1];
              }
            }
          } else {
            // only one member
            newOwner = value.docs[i];
          }
        }

        //update the owner info
        await groupRef.update(
          {'ownerId': newOwner.id,
            'ownerPhotoUrl': newOwner.data().photoUrl}
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
            userId: newOwner.id,
            groupId: groupId,
            postId: '',
            content: groupName,
          }
        );

      }

    }
  );
}