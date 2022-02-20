const functions = require('firebase-functions').region('asia-northeast1');
const uuid = require("uuid");
const admin = require("firebase-admin");
const _db = admin.firestore();


exports.deleteMembersByLastPostDateTime = functions.pubsub.schedule('0 0-23 * * *').onRun(async (context) => {


    const groups = await _db.collection("groups").get();
    if (groups.docs.length === 0) return;

    for (const group of groups.docs) {

        const members = await _db.collection(`groups/${group.data().groupId}/members`).get();

        if (members.docs.length !== 0) {
            for (const member of members.docs) {


                // shown in utc time
                const now = new Date(Date.now());

                const timeZoneOffsetInMinutes = member.data().timeZoneOffsetInMinutes;

                const adjustedTime = new Date(Date.now());

                let localMidnight;
                let localOneAm;

                if (timeZoneOffsetInMinutes > 0) {
                    localMidnight = new Date(adjustedTime.setUTCHours(0, 0, 0, 0) + (60 * 24 - timeZoneOffsetInMinutes) * 60000);
                    localOneAm = new Date(adjustedTime.setUTCHours(1, 0, 0, 0) + (60 * 24 - timeZoneOffsetInMinutes) * 60000);

                } else {
                    // timeZoneOffsetInMinutes <= 0
                    localMidnight = new Date(adjustedTime.setUTCHours(0, 0, 0, 0) - timeZoneOffsetInMinutes * 60000);
                    localOneAm = new Date(adjustedTime.setUTCHours(1, 0, 0, 0) - timeZoneOffsetInMinutes * 60000);

                }

                // calculate only at midnight in the local time, considering some countries (e.g.India) that have odd time zones
                if (localMidnight.getTime() <= now.getTime() && now.getTime() < localOneAm.getTime()) {


                    const lastPostDateTime = new Date(member.data().lastPostDateTime);
                    const differenceInDays = (now.getTime() - lastPostDateTime.getTime()) / (60 * 60 * 24 * 1000);

                    if (differenceInDays > group.data().autoExitDays) {


                        if (member.data().isAlerted === true || members.docs.length === 5) {

                            console.log(`[DELETE] ${member.data().userId} from ${group.data().groupName}, ${group.data().groupId}`);

                            //delete @groups collection
                            await _db.doc(`groups/${group.data().groupId}/members/${member.data().userId}`).delete();

                            //delete @users collection
                            await _db.doc(`users/${member.data().userId}/groups/${group.data().groupId}`).delete();


                            //insert AUTO_EXIT notification
                            const notificationId = uuid.v4();

                            await _db.collection("notifications").doc(notificationId).set({
                                "createdAt": Date.now(),
                                "notificationType": "AUTO_EXIT",
                                "notificationId": notificationId,
                                "userId": member.data().userId,
                                "groupId": group.data().groupId,
                                "postId": "",
                                "content": group.data().groupName,
                            });

                            // delete ALERT_AUTO_EXIT notification
                            await _db.collection("notifications")
                                .where("userId", "==", member.data().userId)
                                .where("notificationType", "==", "ALERT_AUTO_EXIT")
                                .get().then((snapshot) => {
                                    snapshot.forEach((doc) => {
                                        doc.ref.delete();
                                    });
                                });
                        }
                    }
                }
            }
        }
    }
});


exports.alertMembersByLastPostDateTime = functions.pubsub.schedule('0 0-23 * * *').onRun(async (context) => {


    const groups = await _db.collection("groups").get();
    if (groups.docs.length === 0) return;

    for (const group of groups.docs) {

        const members = await _db.collection(`groups/${group.data().groupId}/members`).get();

        if (members.docs.length !== 0) {
            for (const member of members.docs) {

                const timeZoneOffsetInMinutes = member.data().timeZoneOffsetInMinutes;

                // noinspection DuplicatedCode
                const adjustedTime = new Date(Date.now());

                let localMidnight;
                let localOneAm;

                if (timeZoneOffsetInMinutes > 0) {
                    localMidnight = new Date(adjustedTime.setUTCHours(0, 0, 0, 0) + (60 * 24 - timeZoneOffsetInMinutes) * 60000);
                    localOneAm = new Date(adjustedTime.setUTCHours(1, 0, 0, 0) + (60 * 24 - timeZoneOffsetInMinutes) * 60000);

                } else {
                    // timeZoneOffsetInMinutes <= 0
                    localMidnight = new Date(adjustedTime.setUTCHours(0, 0, 0, 0) - timeZoneOffsetInMinutes * 60000);
                    localOneAm = new Date(adjustedTime.setUTCHours(1, 0, 0, 0) - timeZoneOffsetInMinutes * 60000);
                }


                const now = new Date(Date.now());


                // calculate only at midnight in the local time, considering some countries (e.g.India) that have odd time zones
                if (localMidnight.getTime() <= now.getTime() && now.getTime() < localOneAm.getTime()) {

                    const lastPostDateTime = new Date(member.data().lastPostDateTime);
                    const differenceInDays = (now.getTime() - lastPostDateTime.getTime()) / (60 * 60 * 24 * 1000);

                    if (group.data().autoExitDays - 1 <= differenceInDays && differenceInDays < group.data().autoExitDays) {

                        console.log(`[ALERT] ${member.data().userId} from ${group.data().groupName}, ${group.data().groupId}`);

                        //insert notification
                        const notificationId = uuid.v4();

                        await _db.collection("notifications").doc(notificationId).set({
                            "createdAt": Date.now(),
                            "notificationType": "ALERT_AUTO_EXIT",
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
});
