const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { PubSub } = require('@google-cloud/pubsub');

admin.initializeApp();
const pubsub = new PubSub();

exports.scheduledDeleteSwipeManPosts_v1 = functions.pubsub.schedule('every 24 hours').onRun(async () => {
  try {
    const locationPath = 'France'; // Remplacez par la valeur appropriée
    const postsSnapshot = await admin.firestore().collection(`swipe_man/${locationPath}/posts`).get();

    if (postsSnapshot.empty) {
      console.log('No posts found to delete');
      return;
    }

    const batch = admin.firestore().batch();
    postsSnapshot.forEach(doc => {
      const docRef = admin.firestore().collection(`swipe_man/${locationPath}/posts`).doc(doc.id);
      batch.delete(docRef);
    });

    await batch.commit();
    console.log('Posts deleted successfully from swipe_man');

    // Publier un message sur le sujet Pub/Sub après suppression réussie
    const messageId = await pubsub.topic('posts-deleted').publish(Buffer.from('Posts deleted'));
    console.log(`Message ${messageId} published.`);

  } catch (error) {
    console.error("Error deleting posts from swipe_man:", error);
  }
});

exports.scheduledCopyPostsMan_v1 = functions.pubsub.topic('posts-deleted').onPublish(async () => {
    try {
      const locationPath = 'France'; // Remplacez par la valeur appropriée
      const postsSnapshot = await admin.firestore().collection(`posts_man/${locationPath}/posts`).get();
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const newDocRef = admin.firestore().collection(`swipe_man/${locationPath}/posts`).doc(doc.id);
        batch.set(newDocRef, doc.data());
      });
  
      await batch.commit();
      console.log('Posts copied successfully to swipe_man');
    } catch (error) {
      console.error("Error copying posts to swipe_man:", error);
    }
  });
  