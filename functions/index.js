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

  exports.Man_OOTD_Country_France_4_deletePosts = functions.pubsub.topic('topic-Man_OOTD_Country_France_3_postTOswipe').onPublish(async () => {
    try {
      const locationPath = 'France';
      const postsSnapshot = await admin.firestore().collection(`posts_man/${locationPath}/posts`).get();
  
      const batch = admin.firestore().batch();
      postsSnapshot.forEach(doc => {
        const docRef = admin.firestore().collection(`posts_man/${locationPath}/posts`).doc(doc.id);
        batch.delete(docRef);
      });
  
      await batch.commit();
      functions.logger.info('Posts deleted successfully from posts_man');
  
      const messageId = await pubsub.topic('topic-Man_OOTD_Country_France_4_deletePosts').publish(Buffer.from('Posts deleted'));
      functions.logger.info(`Message ${messageId} published.`);
  
    } catch (error) {
      functions.logger.error("Error deleting posts from posts_man:", error);
    }
  });
  
  exports.generateClonedPosts = functions.pubsub.schedule('every 24 hours').onRun(async () => {
    const postPaths = [
      "users/1ktzeQosrEOWFhKjKW5tMGXbfy22/posts/HP9bmPGps1NQufCy22SD",
      "users/1ktzeQosrEOWFhKjKW5tMGXbfy22/posts/IJDGbsUdowDHftsE1tGZ",
      "users/1ktzeQosrEOWFhKjKW5tMGXbfy22/posts/WRuRT0XZ3MWYSK04otkQ",
      "users/1ktzeQosrEOWFhKjKW5tMGXbfy22/posts/u5J17e3m5PfXxNuOcNfR"
    ];
  
    functions.logger.info('generateClonedPosts function started');
  
    try {
      // Récupérer les détails des posts existants
      functions.logger.info('Fetching details of existing posts');
      const posts = await Promise.all(
        postPaths.map(async (postPath) => {
          const postRef = admin.firestore().doc(postPath);
          const postDoc = await postRef.get();
          if (postDoc.exists) {
            functions.logger.info(`Post found with path: ${postPath}`);
            return { ...postDoc.data(), id: postPath, authorRef: postDoc.ref };
          } else {
            functions.logger.error(`No post found with path: ${postPath}`);
          }
          return null;
        })
      );
  
      // Filtrer les posts null
      const validPosts = posts.filter(post => post !== null);
  
      if (validPosts.length === 0) {
        functions.logger.error('No valid posts found to clone');
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
  
        const locationPostRef = admin.firestore().collection(`posts_man/France/posts`).doc(newPostId);
  
        await locationPostRef.set({
          post_ref: originalPost.authorRef,
          date: newPost.date,
        });
  
        functions.logger.info(`Post cloned and added to ${locationPostRef.path}`);
      }
  
      functions.logger.info('10 cloned posts created successfully');
    } catch (error) {
      console.error('Error creating cloned posts:', error);
    }
  });