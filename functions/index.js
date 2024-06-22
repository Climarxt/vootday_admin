const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { PubSub } = require('@google-cloud/pubsub');

admin.initializeApp();
const pubsub = new PubSub();

exports.Man_OOTD_Country_France = functions.pubsub.schedule('every 24 hours').onRun(async () => {
    try {
      const locationPath = 'France';
      const postsSnapshot = await admin.firestore().collection(`feed_ootd_man/${locationPath}/posts`).get();
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const docRef = admin.firestore().collection(`feed_ootd_man/${locationPath}/posts`).doc(doc.id);
        batch.delete(docRef);
      });
  
      await batch.commit();
      functions.logger.info('Posts deleted successfully from feed_ootd_man');
  
      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France').publish(Buffer.from('Posts deleted'));
      functions.logger.info(`Message ${messageId} published.`);
  
    } catch (error) {
      functions.logger.error("Error deleting posts from feed_ootd_man:", error);
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
      functions.logger.info('Posts copied successfully to ');
      
      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_1_swipeTOfeed').publish(Buffer.from('Feed added'));
      functions.logger.info(`Message ${messageId} published.`);
  
    } catch (error) {
      functions.logger.error("Error adding posts from swipe_man to feed_ootd_man", error);
    }
  });

exports.Man_OOTD_Country_France_2_deleteSwipe = functions.pubsub.topic('topic-Man_OOTD_Country_France_1_swipeTOfeed').onPublish(async () => {
  try {
    const locationPath = 'France';
    const postsSnapshot = await admin.firestore().collection(`swipe_man/${locationPath}/posts`).get();

    if (postsSnapshot.empty) {
      functions.logger.info('No posts found to delete');
      return;
    }

    const batch = admin.firestore().batch();
    postsSnapshot.forEach(doc => {
      const docRef = admin.firestore().collection(`swipe_man/${locationPath}/posts`).doc(doc.id);
      batch.delete(docRef);
    });

    await batch.commit();
    functions.logger.info('Posts deleted successfully from swipe_man');

    const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_2_deleteSwipe').publish(Buffer.from('Swipe deleted'));
    functions.logger.info(`Message ${messageId} published.`);

  } catch (error) {
    functions.logger.error("Error deleting posts from swipe_man:", error);
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
      functions.logger.info('Posts copied successfully to swipe_man');

      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_3_postTOswipe').publish(Buffer.from('Swipe added'));
      functions.logger.info(`Message ${messageId} published.`);
  
    } catch (error) {
      functions.logger.error("Error adding posts from posts_man to swipe_man:", error);
    }
  });
  
// const functions2 = require("firebase-functions");

exports.generateClonedPosts = functions.pubsub.schedule('every 24 hours').onRun(async () => {
  const postIds = [
    "HP9bmPGps1NQufCy22SD",
    "IJDGbsUdowDHftsE1tGZ",
    "WRuRT0XZ3MWYSK04otkQ",
    "u5J17e3m5PfXxNuOcNfR"
  ];

  console.log('generateClonedPosts function started');

  try {
    // Récupérer les détails des posts existants
    console.log('Fetching details of existing posts');
    const posts = await Promise.all(
      postIds.map(async (postId) => {
        const querySnapshot = await admin.firestore().collectionGroup('posts').where('__name__', '==', postId).get();
        if (!querySnapshot.empty) {
          const postDoc = querySnapshot.docs[0];
          console.log(`Post found with ID: ${postId}`);
          return { ...postDoc.data(), id: postId, authorRef: postDoc.ref };
        } else {
          console.warn(`No post found with ID: ${postId}`);
        }
        return null;
      })
    );

    // Filtrer les posts null
    const validPosts = posts.filter(post => post !== null);

    if (validPosts.length === 0) {
      console.warn('No valid posts found to clone');
      return null;
    }

    for (let i = 0; i < 10; i++) {
      const originalPost = validPosts[i % validPosts.length]; // Récupérer un post en boucle
      const newPostId = admin.firestore().collection("posts").doc().id;

      const newPost = {
        ...originalPost,
        caption: `${originalPost.caption} (cloned #${i + 1})`,
        likes: 0,
        date: admin.firestore.FieldValue.serverTimestamp(),
      };

      // Déterminer le chemin de la collection basée sur le genre et la localisation
      const genderPath = originalPost.selectedGender === 'Masculin' ? 'posts_man' : 'posts_woman';
      const locationPath = _getLocationPath(originalPost);

      const locationPostRef = admin.firestore().collection(`${genderPath}/${locationPath}/posts`).doc(newPostId);

      await locationPostRef.set({
        post_ref: originalPost.authorRef,
        date: newPost.date,
      });

      console.log(`Post cloned and added to ${locationPostRef.path}`);
    }

    console.log('10 cloned posts created successfully');
  } catch (error) {
    console.error('Error creating cloned posts:', error);
  }
});

// Fonction utilitaire pour obtenir le chemin de localisation
function _getLocationPath(post) {
  let locationPath = '';
  if (post.locationCountry) {
    locationPath += post.locationCountry;
  }
  if (post.locationState) {
    locationPath += `/${post.locationState}`;
  }
  if (post.locationCity) {
    locationPath += `/${post.locationCity}`;
  }
  return locationPath;
}