const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./ServiceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

exports.chatNotifications = functions.firestore
    .document("chats/{groupId}")
    .onUpdate((change, context) => {
      const doc = change.after.data();
      const d1 = new Date();
      doc.messages.forEach((element) => {
        const d2 = new Date(element.createdAt.toDate());
        if (d1.getTime() - d2.getTime() < 10000) {
          doc.users.forEach((user) => {
            if (user.id != element.idUser) {
              let fcmToken;
              let userName;
              db.collection("fcmTokens")
                  .doc(element.idUser).get().then((userDoc) => {
                    userName = userDoc.data()["userName"];
                    db.collection("fcmTokens")
                        .doc(user.id).get().then((document) => {
                          fcmToken = document.data()["fcmToken"];
                          console.log(fcmToken);
                          console.log(userName);
                          const payload = {
                            notification: {
                              title: userName,
                              body: element.message,
                              badge: "1",
                              sound: "default",
                              click_action: "FLUTTER_NOTIFICATION_CLICK",
                            },
                            data: {
                              id: element.idUser,
                              messageType: "chatMessage",
                            },
                          };
                          admin
                              .messaging()
                              .sendToDevice(fcmToken, payload)
                              .then((response) => {
                                console.log("Sent the notification");
                              });
                        });
                  });
            }
            return;
          });
        }
        return;
      });
      return;
    });

exports.connectionNotifications = functions.firestore
    .document("Notifications/{groupId}")
    .onWrite((change, context) => {
      const val = Object.values(change.before.data());
      const oldIds = [];
      val[0].forEach((element) => {
        oldIds.push(element["id"]);
      });
      const val1 = Object.values(change.after.data());
      let senderId = "";
      let connType = "";
      const receiverId = change.after.id;
      val1[0].forEach((element) => {
        senderId = element["id"];
        connType = element["type"];
        return;
      });
      // console.log("Sender ID");
      // console.log(senderId);
      // console.log("Receiver ID");
      // console.log(receiverId);
      let recieverFcmToken;
      let recieverUserName;
      let senderUName;
      if (connType == "connectionRequestAccepted" ||
      connType == "connectionRequestReceived") {
        db.collection("fcmTokens")
            .doc(receiverId).get().then((document) => {
              recieverFcmToken = document.data()["fcmToken"];
              recieverUserName = document.data()["userName"];
            }).then((_) => {
              db.collection("fcmTokens")
                  .doc(senderId).get().then((document) => {
                    senderUName = document.data()["userName"];
                  }).then((_) => {
                    console.log(recieverFcmToken);
                    console.log(recieverUserName);
                    console.log(senderUName);
                    let message = "";
                    if (connType == "connectionRequestAccepted") {
                      message =
                        `${senderUName} has accepted your connection request`;
                      const payload = {
                        notification: {
                          title: "Jumpin",
                          body: message,
                          badge: "1",
                          sound: "default",
                          click_action: "FLUTTER_NOTIFICATION_CLICK",
                        },
                        data: {
                          id: senderId,
                          messageType: connType,
                        },
                      };
                      admin
                          .messaging()
                          .sendToDevice(recieverFcmToken, payload)
                          .then((response) => {
                            console.log("Sent the notification");
                          });
                    }
                    if (connType == "connectionRequestReceived") {
                      message =
                        `${senderUName} has sent you a connection request`;
                      const payload = {
                        notification: {
                          title: "Jumpin",
                          body: message,
                          badge: "1",
                          sound: "default",
                          click_action: "FLUTTER_NOTIFICATION_CLICK",
                        },
                        data: {
                          id: senderId,
                          messageType: connType,
                        },
                      };
                      admin
                          .messaging()
                          .sendToDevice(recieverFcmToken, payload)
                          .then((response) => {
                            console.log("Sent the notification");
                          });
                    }
                  });
            });
      }
      return;
    });
