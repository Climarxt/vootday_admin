const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { PubSub } = require('@google-cloud/pubsub');

admin.initializeApp();
const pubsub = new PubSub();

exports.Man_OOTD_Country_France = functions.pubsub.schedule('every 24 hours').onRun(async () => {
    try {
      const locationPath = 'France';
      const postsSnapshot = await admin.firestore().collection(`feed_ootd_man/${locationPath}/posts`).get();
  
      if (postsSnapshot.empty) {
        console.log('No posts found to delete');
        return;
      }
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const docRef = admin.firestore().collection(`feed_ootd_man/${locationPath}/posts`).doc(doc.id);
        batch.delete(docRef);
      });
  
      await batch.commit();
      console.log('Posts deleted successfully from feed_ootd_man');
  
      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France').publish(Buffer.from('Posts deleted'));
      console.log(`Message ${messageId} published.`);
  
    } catch (error) {
      console.error("Error deleting posts from feed_ootd_man:", error);
    }
  });

  exports.Man_OOTD_Country_France_1_swipeTOfeed = functions.pubsub.topic('topic-Man_OOTD_Country_France').onPublish(async () => {
    try {
      const locationPath = 'France';
      const postsSnapshot = await admin.firestore().collection(`swipe_man/${locationPath}/posts`).get();
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const newDocRef = admin.firestore().collection(`feed_ootd_man/${locationPath}/posts`).doc(doc.id);
        batch.set(newDocRef, doc.data());
      });
  
      await batch.commit();
      console.log('Posts copied successfully to ');
      
      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_1_swipeTOfeed').publish(Buffer.from('Feed added'));
      console.log(`Message ${messageId} published.`);
  
    } catch (error) {
      console.error("Error adding posts from swipe_man to feed_ootd_man", error);
    }
  });

exports.Man_OOTD_Country_France_2_deleteSwipe = functions.pubsub.topic('topic-Man_OOTD_Country_France_1_swipeTOfeed').onPublish(async () => {
  try {
    const locationPath = 'France';
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

    const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_2_deleteSwipe').publish(Buffer.from('Swipe deleted'));
    console.log(`Message ${messageId} published.`);

  } catch (error) {
    console.error("Error deleting posts from swipe_man:", error);
  }
});

exports.Man_OOTD_Country_France_3_postTOswipe = functions.pubsub.topic('topic-Man_OOTD_Country_France_2_deleteSwipe').onPublish(async () => {
    try {
      const locationPath = 'France';
      const postsSnapshot = await admin.firestore().collection(`posts_man/${locationPath}/posts`).get();
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const newDocRef = admin.firestore().collection(`swipe_man/${locationPath}/posts`).doc(doc.id);
        batch.set(newDocRef, doc.data());
      });
  
      await batch.commit();
      console.log('Posts copied successfully to swipe_man');

      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_3_postTOswipe').publish(Buffer.from('Swipe added'));
      console.log(`Message ${messageId} published.`);
  
    } catch (error) {
      console.error("Error adding posts from posts_man to swipe_man:", error);
    }
  });
  