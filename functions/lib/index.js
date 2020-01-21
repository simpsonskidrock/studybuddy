"use strict";
/* Start in terminal with:
/ firebase deploy --only functions
*/
// tipps: https://firebase.google.com/docs/functions/get-started
// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();
// --------------- Likes --------------- //
exports.updatedLikes = functions.database.ref('/Users/{userId}/likedUsers')
    .onWrite((change, context) => {
    const uid = context.params.userId;
    const oldEntrys = change.before.val();
    const newEntrys = change.after.val();
    console.log(`User ${uid}: Updated Likes from ${oldEntrys} to: ${newEntrys}`);
    if (oldEntrys !== newEntrys) {
        // deleted likedUser
        for (let entry in oldEntrys) {
            if (!newEntrys || !newEntrys.includes(oldEntrys[entry])) {
                console.log("deleted:", oldEntrys[entry]);
            }
        }
        // added likedUser
        for (let entry in newEntrys) {
            if (!oldEntrys || !oldEntrys.includes(newEntrys[entry])) {
                console.log("added:", newEntrys[entry]);
                const refUser = change.after.ref.parent;
                const refOtherUser = change.after.ref.parent.parent.child(newEntrys[entry]);
                var numberOfEntrysContacts = '0';
                // get number of contacts
                change.after.ref.parent.child('contacts').once('value', (snapshot) => {
                    if (snapshot.val()) {
                        numberOfEntrysContacts = snapshot.val().length;
                    }
                });
                // snapshot of other user
                refOtherUser.once('value', (snapshot) => {
                    const snapshotLikedUsers = snapshot.val().likedUsers;
                    const snapshotContacts = snapshot.val().contacts;
                    for (let snapshotEntry in snapshotLikedUsers) {
                        // check if other user liked user
                        if (snapshotLikedUsers[snapshotEntry] == uid) {
                            // otherUser: add user to other users contacts
                            if (snapshotContacts) {
                                refOtherUser.child('contacts').child(snapshotContacts.length).set(uid);
                            }
                            else {
                                refOtherUser.child('contacts').child('0').set(uid);
                            }
                            // otherUser: delete user of other users likedUsers
                            refOtherUser.child('likedUsers').child(snapshotEntry).set(null);
                            // user: add other user to contacts
                            refUser.child('contacts').child(numberOfEntrysContacts).set(newEntrys[entry]);
                            // user: delete other user of likedUsers
                            refUser.child('likedUsers').child(entry).set(null);
                        }
                    }
                });
            }
        }
        return change.after.ref.parent.child('likedUsers').set(newEntrys);
    }
});
// --------------- Contacts --------------- //
exports.updatedContacts = functions.database.ref('/Users/{userId}/contacts')
    .onWrite((change, context) => {
    const uid = context.params.userId;
    const oldEntrys = change.before.val();
    const newEntrys = change.after.val();
    console.log(`User ${uid}: Updated Contacts from ${oldEntrys} to: ${newEntrys}`);
    if (oldEntrys !== newEntrys) {
        // deleted contact
        for (let entry in oldEntrys) {
            if (!newEntrys || !newEntrys.includes(oldEntrys[entry])) {
                const refOtherUser = change.after.ref.parent.parent.child(oldEntrys[entry]).child('contacts');
                refOtherUser.once('value', (snapshot) => {
                    const snapshotEntrys = snapshot.val();
                    for (let snapshotEntry in snapshotEntrys) {
                        if (snapshotEntrys[snapshotEntry] == uid) {
                            refOtherUser.child(snapshotEntry).set(null);
                        }
                    }
                });
                console.log("deleted:", oldEntrys[entry]);
            }
        }
        // added contact
        for (let entry in newEntrys) {
            if (newEntrys && (!oldEntrys || !oldEntrys.includes(newEntrys[entry]))) {
                console.log("added:", newEntrys[entry]);
            }
        }
        return change.after.ref.parent.child('contacts').set(newEntrys);
    }
});
//# sourceMappingURL=index.js.map