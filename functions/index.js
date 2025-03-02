const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyAdminOnTeacherRequest = functions.firestore
    .document("teachers_pending_approvals/{requestId}")  // Path to teacher requests
    .onCreate(async (snapshot, context) => {
        const payload = {
            notification: {
                title: "New Teacher Request",
                body: "A new teacher has requested approval!",
                sound: "default",
            },
            topic: "admin_notifications",  // Sending to admins subscribed to this topic
        };

        await admin.messaging().send(payload);
        console.log("Notification sent to admins!");
    });
