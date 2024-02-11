import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config/configs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot userSnap =
          await _firebaseFirestore.collection(Paths.users).doc(userId).get();

      if (userSnap.exists) {
        debugPrint(
            'getUserById : User document found. Converting to User object...');
        return User.fromDocument(userSnap);
      } else {
        debugPrint("getUserById : L'user n'existe pas.");
        return null;
      }
    } catch (e) {
      debugPrint(
          'getUserById : Une erreur est survenue lors de la récupération de l\'user: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateUserField(
      String userId, String field, dynamic newValue) async {
    try {
      await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .update({field: newValue});
      debugPrint('updateUserField: Event $userId updated successfully.');
    } catch (e) {
      debugPrint('updateUserField: Error updating user - ${e.toString()}');
      rethrow;
    }
  }

  Future<List<User>> getUserFollowers({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getUserFollowers : Attempting to fetch user followers from Firestore...');

      // Récupérer les documents de la sous-collection 'userFollowers'
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      debugPrint('getUserFollowers : Followers documents fetched.');

      // Créer une liste pour les futures informations des utilisateurs
      List<Future<User?>> futureUsers = followersSnapshot.docs.map((doc) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        return userDoc.exists ? User.fromDocument(userDoc) : null;
      }).toList();

      // Résoudre tous les futures pour obtenir les informations détaillées des utilisateurs
      List<User> followers =
          (await Future.wait(futureUsers)).whereType<User>().toList();

      debugPrint(
          'getUserFollowers : User objects created. Total followers: ${followers.length}');

      return followers;
    } catch (e) {
      debugPrint(
          'getUserFollowers : An error occurred while fetching followers: ${e.toString()}');
      return [];
    }
  }

  Future<List<User>> getUserFollowing({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getUserFollowing : Attempting to fetch user followers from Firestore...');

      // Récupérer les documents de la sous-collection 'userFollowing'
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(userId)
          .collection('userFollowing')
          .get();

      debugPrint('getUserFollowing : Followers documents fetched.');

      // Créer une liste pour les futures informations des utilisateurs
      List<Future<User?>> futureUsers = followersSnapshot.docs.map((doc) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        return userDoc.exists ? User.fromDocument(userDoc) : null;
      }).toList();

      // Résoudre tous les futures pour obtenir les informations détaillées des utilisateurs
      List<User> followers =
          (await Future.wait(futureUsers)).whereType<User>().toList();

      debugPrint(
          'getUserFollowing : User objects created. Total followers: ${followers.length}');

      return followers;
    } catch (e) {
      debugPrint(
          'getUserFollowing : An error occurred while fetching followers: ${e.toString()}');
      return [];
    }
  }

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    // Convertir la requête en minuscules
    String lowerCaseQuery = query.toLowerCase();

    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username_lowercase', isGreaterThanOrEqualTo: lowerCaseQuery)
        .where('username_lowercase', isLessThan: '$lowerCaseQuery\uf8ff')
        .get();

    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  Future<List<User>> searchUsersBrand({required String query}) async {
    // Convertir la requête en minuscules
    String lowerCaseQuery = query.toLowerCase();

    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username_lowercase', isGreaterThanOrEqualTo: lowerCaseQuery)
        .where('username_lowercase', isLessThan: '$lowerCaseQuery\uf8ff')
        .where('selectedGender', isEqualTo: 'Brand')
        .get();

    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({
    required String userId,
    required String followUserId,
  }) {
    // Add followUser to user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});
    // Add user to followUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.follow,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(followUserId)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  void unfollowUser({
    required String userId,
    required String unfollowUserId,
  }) {
    // Remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();
    // Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }

  Future<int> getCountManUsers() async {
    try {
      debugPrint(
          'getCountManUsers : Récupération du nombre d\'user masculin...');

      // Requête pour filtrer les événements où 'done' est vrai
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .where('selectedGender', isEqualTo: 'Masculin')
          .get();

      // Le nombre de documents correspondants représente le nombre d'événements terminés
      int count = querySnapshot.docs.length;

      debugPrint('getCountManUsers : Nombre d\'user masculin terminés: $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountManUsers : Erreur lors du comptage des users - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<int> getCountWomanUsers() async {
    try {
      debugPrint(
          'getCountWomanUsers : Récupération du nombre d\'user masculin...');

      // Requête pour filtrer les événements où 'done' est vrai
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .where('selectedGender', isEqualTo: 'Féminin')
          .get();

      // Le nombre de documents correspondants représente le nombre d'événements terminés
      int count = querySnapshot.docs.length;

      debugPrint(
          'getCountWomanUsers : Nombre d\'user féminin terminés: $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountWomanUsers : Erreur lors du comptage des users - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<int> getCountAllUsers() async {
    try {
      debugPrint('getCountAllUsers : Récupération du nombre d\'users...');

      // Requête pour filtrer les événements où 'done' est vrai
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .where('selectedGender', isNotEqualTo: 'Brand')
          .get();

      // Le nombre de documents correspondants représente le nombre d'événements terminés
      int count = querySnapshot.docs.length;

      debugPrint('getCountAllUsers : Nombre d\'user terminés: $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountAllUsers : Erreur lors du comptage des users - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      debugPrint('getAllUsers : Fetching all users from Firestore...');

      // Récupérer tous les documents de la collection 'users'
      QuerySnapshot usersSnapshot =
          await _firebaseFirestore.collection(Paths.users).get();

      debugPrint('getAllUsers : All user documents fetched.');

      // Transformer chaque document en objet User, puis en Map<String, dynamic>
      List<Map<String, dynamic>> users = usersSnapshot.docs.map((doc) {
        User user = User.fromDocument(doc);
        return {
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'location': user.location,
          'followers': user.followers,
          'following': user.following,
          'selectedGender': user.selectedGender,
          'username_lowercase': user.username_lowercase,
        };
      }).toList();

      debugPrint(
          'getAllUsers : User objects transformed. Total users: ${users.length}');
      debugPrint("DEBUG : $users");

      return users;
    } catch (e) {
      debugPrint(
          'getAllUsers : An error occurred while fetching users: ${e.toString()}');
      return [];
    }
  }

  Future<int> getCountPostUser(String userId) async {
    try {
      debugPrint(
          'getCountPostUser : Récupération du nombre de posts de l\'utilisateur $userId...');
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.posts)
          .where('author',
              isEqualTo:
                  FirebaseFirestore.instance.collection('users').doc(userId))
          .get();

      int count = querySnapshot.docs.length;

      debugPrint(
          'getCountPostUser : Nombre de posts de l\'utilisateur $userId : $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountPostUser : Erreur lors du comptage des posts - ${e.toString()}');
      return 0;
    }
  }

  Future<int> getCountCollectionUser(String userId) async {
    try {
      debugPrint(
          'getCountCollectionUser : Récupération du nombre de collection dans la sous-collection de l\'utilisateur $userId...');

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection('mycollection')
          .get();

      int count = querySnapshot.docs.length;

      debugPrint(
          'getCountCollectionUser : Nombre de documents dans la sous-collection pour l\'utilisateur $userId: $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountCollectionUser : Erreur lors du comptage des documents - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  Future<int> getCountLikesUser(String userId) async {
    try {
      debugPrint(
          'getCountLikesUser : Récupération du nombre de likes dans la sous-collection de l\'utilisateur $userId...');

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection('likes')
          .get();

      int count = querySnapshot.docs.length;

      debugPrint(
          'getCountLikesUser : Nombre de likes dans la sous-collection pour l\'utilisateur $userId: $count');
      return count;
    } catch (e) {
      debugPrint(
          'getCountLikesUser : Erreur lors du comptage des documents - ${e.toString()}');
      return 0; // Retourne 0 en cas d'erreur
    }
  }
}
