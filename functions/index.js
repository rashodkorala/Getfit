const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

// Create a Gym Reminder
exports.createGymReminder = functions.https.onCall(async (data, context) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated",
          "User is not authenticated");
    }

    const {date, time} = data;

    // Optionally validate date and time here

    const userId = context.auth.uid;

    const gymReminder = {
      userId,
      date,
      time,
    };

    const docRef = await firestore.collection("gym_reminders").add(gymReminder);

    return {message: "Gym reminder created successfully!", docId: docRef.id};
  } catch (error) {
    console.error("Error creating gym reminder:", error);
    throw new functions.https.HttpsError("internal", "Error creating reminder");
  }
});
