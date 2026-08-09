const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

const STALE_TOKEN_ERRORS = new Set([
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
]);

async function sendToTokens(tokens, notification, data, userDocRef) {
  if (!tokens || tokens.length === 0) return;

  const response = await messaging.sendEachForMulticast({
    tokens,
    notification,
    data,
  });

  const staleTokens = [];
  response.responses.forEach((res, idx) => {
    if (!res.success && STALE_TOKEN_ERRORS.has(res.error && res.error.code)) {
      staleTokens.push(tokens[idx]);
    }
  });
  if (staleTokens.length > 0 && userDocRef) {
    await userDocRef.update({fcmTokens: FieldValue.arrayRemove(...staleTokens)});
  }
}

// Fires for every doc already written to the "notifications" collection
// (favourites, apartment interest, status changes, etc. all use this collection today).
exports.sendNotificationPush = onDocumentCreated(
    "notifications/{notificationId}",
    async (event) => {
      const data = event.data.data();
      const email = data.email;
      if (!email) return;

      const userSnap = await db
          .collection("users")
          .where("email", "==", email)
          .limit(1)
          .get();
      if (userSnap.empty) return;

      const userDoc = userSnap.docs[0];
      const tokens = userDoc.data().fcmTokens || [];
      if (tokens.length === 0) return;

      const body = data.msg || "You have a new notification in BestRent";
      await sendToTokens(
          tokens,
          {title: "BestRent", body},
          {type: "app", notificationId: event.params.notificationId},
          userDoc.ref,
      );
    },
);

// Fires for every new chat message written under chat/{chatRoomId}/messages.
exports.sendChatMessagePush = onDocumentCreated(
    "chat/{chatRoomId}/messages/{messageId}",
    async (event) => {
      const data = event.data.data();
      const receiverId = data.receiverId;
      const senderId = data.senderId;
      const text = data.message || "";
      if (!receiverId) return;

      const userSnap = await db
          .collection("users")
          .where("uid", "==", receiverId)
          .limit(1)
          .get();
      if (userSnap.empty) return;

      const userDoc = userSnap.docs[0];
      const tokens = userDoc.data().fcmTokens || [];
      if (tokens.length === 0) return;

      let senderName = data.senderEmail || "BestRent";
      const senderSnap = await db
          .collection("users")
          .where("uid", "==", senderId)
          .limit(1)
          .get();
      if (!senderSnap.empty) {
        senderName = senderSnap.docs[0].data().username || senderName;
      }

      await sendToTokens(
          tokens,
          {
            title: senderName,
            body: text.length > 120 ? `${text.slice(0, 117)}...` : text,
          },
          {type: "chat", senderId: senderId || ""},
          userDoc.ref,
      );
    },
);
