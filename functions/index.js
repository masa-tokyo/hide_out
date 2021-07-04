const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const _db = admin.firestore();
const uuid = require('uuid');



exports.deleteMembersByLastPostDateTime = functions.pubsub.schedule('0 0-23 * * *').onRun(async (context) => {

  //calculate lastPostDateTime
  const groups = await _db.collection("groups").get();
  if (groups.docs.length == 0) return;

  for (const group of groups.docs) {

    const members = await _db.collection(`groups/${group.data().groupId}/members`).get(); 

    if (members.docs.length != 0) {
      for (const member of members.docs) {

        //TODO: for now, apply this to only masa
        if(member.data().userId == "0fzwzx2ZJAQvSkA052nsO9kPpy33"){
  
          const lastPostDateTime = new Date(member.data().lastPostDateTime);
    
          const now = new Date(Date.now());
    
          const differenceInDays = (now.getTime()- lastPostDateTime.getTime())
                                                    / (60 * 60 * 24 * 1000);
    
    
          if (differenceInDays > group.data().autoExitDays) {

            console.log(`${member.data().userId} was 
            deleted from ${group.data().groupName}, ${group.data().groupId}`);

            //delete @groups collection
            await _db.doc(`groups/${group.data().groupId}/members/${member.data().userId}`).delete();
  
            //delete @users collection
            await _db.doc(`users/${member.data().userId}/groups/${group.data().groupId}`).delete();


            //insert notification
            const notificationId = uuid.v1();

            await _db.collection("notifications").doc(notificationId).set({
              "createdAt": Date.now(),
              "notificationType": "AUTO_EXIT",
              "notificationId": notificationId,
              "userId": member.data().userId,
              "groupId": group.data().groupId,
              "postId": "",
              "content": group.data().groupName,
            });
    
    
          } 
    
  
        }
  
  
  
  
      }
    }





  }

  return;


});