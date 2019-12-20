// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

/*exports.newLike = functions.database.ref('/Users/{userId}/likedUsers')
    .onWrite((change: any, context: any) => {
        const original = change.after.val()
        console.log("LowerCasing", context.params.userId, original)
        const lowercase = original.toLowerCase()
        return change.afer.ref.parent.child('lowercase').set(lowercase)
    })*/