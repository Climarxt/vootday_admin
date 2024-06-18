const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const cors = require('cors')({ origin: true });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = onRequest((request, response) => {
  cors(request, response, () => {
    logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  });
});
