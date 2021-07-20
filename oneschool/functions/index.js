const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();


exports.changeLastMessage = functions.firestore
    .document("rooms/{roomId}/messages/{messageId}")
    .onUpdate((change, context) => {
      const message = change.after.data();
      if (message) {
        return db.doc("rooms/" + context.params.roomId).update({
          lastMessages: [message],
          updatedAt: message["createdAt"],
        });
      } else {
        return null;
      }
    });

exports.changeMessageStatus = functions.firestore
    .document("rooms/{roomId}/messages/{messageId}")
    .onWrite((change) => {
      const message = change.after.data();
      if (message) {
        if (["delivered", "seen"].includes(message.status)) {
          return null;
        } else {
          return change.after.ref.update({
            status: "delivered",
          });
        }
      } else {
        return null;
      }
    });
