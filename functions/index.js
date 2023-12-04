// js function that works with firebase cloud functions 
// to send scheduled notifications to users
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.checkAndSendReminders = functions.pubsub.schedule("every 1 minutes")
    .timeZone("America/St_Johns") // Updated to Newfoundland Time Zone
    .onRun(async (context) => {
      const now = admin.firestore.Timestamp.now();
      const profilesSnapshot = await admin.firestore().collection(
          "profiles").get();

      // Using for loop for proper async/await handling
      for (const profileDoc of profilesSnapshot.docs) {
        const remindersSnapshot = await profileDoc.ref.collection(
            "gym_reminders")
            .where("reminderTime", "<=", now)
            .get();

        for (const reminderDoc of remindersSnapshot.docs) {
          const reminder = reminderDoc.data();

          if (reminder.token) {
            const payload = {
              notification: {
                title: "Gym Reminder",
                body: "It's time for your gym session!",
              },
              token: reminder.token,
            };

            try {
              await admin.messaging().send(payload);
            // Optionally delete the reminder after sending
            // await reminderDoc.ref.delete();
            } catch (error) {
              console.error("Error sending notification:", error);
            }
          }
        }
      }

      return null;
    });
