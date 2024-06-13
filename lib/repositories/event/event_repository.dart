import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/config/logger/logger.dart';
import 'package:vootday_admin/models/models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  EventRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('EventRepository');
  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventSnap =
          await _firebaseFirestore.collection(Paths.events).doc(eventId).get();

      if (eventSnap.exists) {
        debugPrint(
            'getEventById : Event document found. Converting to Event object...');
        return Event.fromDocument(eventSnap);
      } else {
        debugPrint("getEventById : L'événement n'existe pas.");
        return null;
      }
    } catch (e) {
      debugPrint(
          'getEventById : Une erreur est survenue lors de la récupération de l\'événement: ${e.toString()}');
      return null;
    }
  }

  Future<Event?> getLatestEvent() async {
    try {
      debugPrint(
          'getLatestEvent: Attempting to fetch the latest event document from Firestore...');
      // Fetch the latest event by date
      QuerySnapshot eventSnap = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        debugPrint(
            'getLatestEvent: Latest event document fetched. Converting to Event object...');
        DocumentSnapshot doc = eventSnap.docs.first;
        Event? latestEvent = await Event.fromDocument(doc);
        debugPrint('getLatestEvent: Event data - ${latestEvent?.toDocument()}');
        return latestEvent;
      } else {
        debugPrint('getLatestEvent: No events found.');
        return null;
      }
    } catch (e) {
      debugPrint(
          'getLatestEvent: An error occurred while fetching the latest event: $e');
      return null;
    }
  }

  Future<List<Event?>> getEventsDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsDone : Attempting to fetch event documents from Firestore...');
      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent',
                descending: true) // Assume we order by the event date.
            .limit(100) // Or some other limit you prefer.
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint('getEventsDone : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2) // Fetch next set of events.
            .get();
      }

      debugPrint(
          'getEventsDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsDone : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint('getEventsDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event?>> getEventsDoneByUserId({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsDoneByUserId : Attempting to fetch event documents from Firestore for Brand : $userId ...');

      // Créer une référence à un document utilisateur
      DocumentReference userRef =
          _firebaseFirestore.collection(Paths.users).doc(userId);

      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('user_ref', isEqualTo: userRef) // Ajouter cette ligne
            .orderBy('dateEvent', descending: true)
            .limit(100)
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint(
              'getEventsDoneByUserId : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('user_ref', isEqualTo: userRef) // Ajouter cette ligne
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2)
            .get();
      }

      debugPrint(
          'getEventsDoneByUserId : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsDoneByUserId : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint(
            'getEventsDoneByUserId : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsDoneByUserId : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event>> getThisEndedEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'getThisEndedEvents: Attempting to fetch events from Firestore for the current week.');

      QuerySnapshot eventSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('done', isEqualTo: true)
          .orderBy('dateEvent', descending: true)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        for (var doc in eventSnap.docs) {
          Event? event = await Event.fromDocument(doc);
          if (event != null) {
            eventsList.add(event);
          }
        }
        debugPrint('getThisEndedEvents: Events fetched successfully.');
      } else {
        debugPrint('getThisEndedEvents: No events found for the current week.');
      }
    } catch (e) {
      debugPrint(
          'getThisEndedEvents: Error occurred while fetching events - $e');
    }
    return eventsList;
  }

  Future<List<Event>> getComingSoonEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'getComingSoonEvents: Attempting to fetch future events from Firestore.');

      QuerySnapshot eventSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('done', isEqualTo: false)
          .orderBy('dateEvent', descending: false)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        for (var doc in eventSnap.docs) {
          Event? event = await Event.fromDocument(doc);
          if (event != null) {
            eventsList.add(event);
          }
        }
        debugPrint('getComingSoonEvents: Future events fetched successfully.');
      } else {
        debugPrint('getComingSoonEvents: No future events found.');
      }
    } catch (e) {
      debugPrint(
          'getComingSoonEvents: Error occurred while fetching future events - $e');
    }
    return eventsList;
  }

  Future<List<Map<String, dynamic>>> getUpComingEvents() async {
    const String functionName = 'getUpComingEvents';
    try {
      logger.logInfo(functionName, 'Fetching all events from Firestore...');

      QuerySnapshot eventsSnapshot = await _firebaseFirestore
          .collection('events')
          .where('done', isEqualTo: false)
          .get();

      logger.logInfo(functionName, 'All event documents fetched.');

      List<Future<Map<String, dynamic>>> futureEvents = [];

      for (var doc in eventsSnapshot.docs) {
        futureEvents.add(_createEventMap(doc));
      }

      List<Map<String, dynamic>> events = await Future.wait(futureEvents);

      logger.logInfo(functionName, 'Event objects transformed.',
          {'totalEvents': events.length});

      return events;
    } catch (e) {
      logger.logError(functionName, 'An error occurred while fetching events',
          {'error': e.toString()});
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEndedEvents() async {
    try {
      debugPrint('getEndedEvents : Fetching all events from Firestore...');

      // Récupérer tous les documents de la collection 'events'
      QuerySnapshot eventsSnapshot = await _firebaseFirestore
          .collection('events')
          .where('done', isEqualTo: true)
          .get();

      debugPrint('getEndedEvents : All event documents fetched.');

      // Liste pour stocker les futures des événements
      List<Future<Map<String, dynamic>>> futureEvents = [];

      // Parcourir les documents et créer un future pour chaque événement
      for (var doc in eventsSnapshot.docs) {
        futureEvents.add(_createEventMap(doc));
      }

      // Attendre que tous les futures se terminent
      List<Map<String, dynamic>> events = await Future.wait(futureEvents);

      debugPrint(
          'getEndedEvents : Event objects transformed. Total events: ${events.length}');

      return events;
    } catch (e) {
      debugPrint(
          'getEndedEvents : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  // Fonction pour créer un Map d'événement à partir d'un document
  Future<Map<String, dynamic>> _createEventMap(DocumentSnapshot doc) async {
    const String functionName = '_createEventMap';
    try {
      Event event = await Event.fromDocument(doc) as Event;
      Map<String, dynamic> eventMap = {
        'id': event.id,
        'author':
            event.author.toDocument(), // Convert Brand to Map<String, dynamic>
        'imageUrl': event.imageUrl,
        'caption': event.caption,
        'participants': event.participants,
        'title': event.title,
        'date': event.date,
        'dateEvent': event.dateEvent,
        'dateEnd': event.dateEnd,
        'tags': event.tags,
        'reward': event.reward,
        'done': event.done,
        'logoUrl': event.logoUrl,
        'user_ref':
            event.user_ref.toDocument(), // Convert User to Map<String, dynamic>
        'brandName': event.author.author,
      };

      logger.logInfo(functionName, 'Event mapped', {
        'id': event.id,
        'author': event.author.author,
        'title': event.title,
      });

      return eventMap;
    } catch (e) {
      logger.logError(
          functionName, 'Error mapping event', {'error': e.toString()});
      return {};
    }
  }

  Future<int> getTotalLikesForEventPosts(String eventId) async {
    int totalLikes = 0;

    try {
      debugPrint(
          'getTotalLikesForEventPosts : Fetching posts for event: $eventId...');

      // Accéder à la sous-collection 'feed_event'
      QuerySnapshot feedEventSnap = await _firebaseFirestore
          .collection(Paths.events)
          .doc(eventId)
          .collection(
              'feed_event') // Assurez-vous que le nom de la sous-collection est correct
          .get();

      // Additionner les likes de chaque post
      for (var doc in feedEventSnap.docs) {
        var postData = doc.data() as Map<String, dynamic>;
        var likes = postData['likes'];

        // Vérifier le type de la valeur 'likes' et la convertir en int
        if (likes is int) {
          totalLikes += likes;
        } else if (likes is double) {
          totalLikes += likes.toInt();
        } else {
          // Gérer le cas où 'likes' n'est ni un int ni un double
          debugPrint(
              'getTotalLikesForEventPosts : Unexpected type for likes in document ${doc.id}');
        }
      }

      debugPrint(
          'getTotalLikesForEventPosts : Total likes for event $eventId: $totalLikes');
    } catch (e) {
      debugPrint(
          'getTotalLikesForEventPosts : Error occurred - ${e.toString()}');
    }

    return totalLikes;
  }

  Future<int> getCountEndedEvents() async {
    const String functionName = 'getCountEndedEvents';
    try {
      logger.logInfo(
          functionName, 'Récupération du nombre d\'événements terminés...');

      // Requête pour filtrer les événements où 'done' est vrai
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: true)
          .get();

      // Le nombre de documents correspondants représente le nombre d'événements terminés
      int count = querySnapshot.docs.length;

      logger.logInfo(functionName, 'Nombre d\'événements terminés récupéré',
          {'count': count});
      return count;
    } catch (e) {
      logger.logError(functionName, 'Erreur lors du comptage des événements',
          {'error': e.toString()});
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<int> getCountComingEvents() async {
    const String functionName = 'getCountComingEvents';
    try {
      logger.logInfo(
          functionName, 'Récupération du nombre d\'événements terminés...');

      // Requête pour filtrer les événements où 'done' est faux
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: false)
          .get();

      // Le nombre de documents correspondants représente le nombre d'événements à venir
      int count = querySnapshot.docs.length;

      logger.logInfo(
          functionName, 'Nombre d\'événements terminés', {'count': count});
      return count;
    } catch (e) {
      logger.logError(functionName, 'Erreur lors du comptage des événements',
          {'error': e.toString()});
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<int> getRemainingDaysForEvent(String eventId) async {
    try {
      // Utiliser getEventById pour récupérer l'objet Event
      final event = await getEventById(eventId);

      if (event != null) {
        final currentDate = DateTime.now();
        final endDate = event.dateEnd;
        // Calcul de la différence en jours
        final difference = endDate.difference(currentDate).inDays;

        // Si la différence est négative, cela signifie que la date de fin est passée
        return difference < 0 ? 0 : difference;
      } else {
        debugPrint(
            'getRemainingDaysForEvent : Aucun événement trouvé pour l\'ID $eventId.');
        return 0;
      }
    } catch (e) {
      debugPrint('getRemainingDaysForEvent : Erreur - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<void> updateEventField(
      String eventId, String field, dynamic newValue) async {
    try {
      await _firebaseFirestore
          .collection(Paths.events)
          .doc(eventId)
          .update({field: newValue});
      debugPrint('updateEventField: Event $eventId updated successfully.');
    } catch (e) {
      debugPrint('updateEventField: Error updating event - ${e.toString()}');
      rethrow;
    }
  }

  Future<void> createEvent({required Event event}) async {
    debugPrint('createEvent in Repository called with event: ${event.id}');
    try {
      await _firebaseFirestore.collection(Paths.events).add(event.toDocument());
      debugPrint('Event successfully added to Firestore');
    } catch (e) {
      debugPrint('Error adding event to Firestore: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firebaseFirestore.collection(Paths.events).doc(eventId).delete();
      debugPrint('deleteEvent: Event $eventId deleted successfully.');
    } catch (e) {
      debugPrint('deleteEvent: Error deleting event - ${e.toString()}');
      rethrow;
    }
  }
}
