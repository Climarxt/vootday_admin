import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '/repositories/storage/base_storage_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<String> uploadThumbnailImage(
      {required Uint8List thumbnailImageBytes}) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('thumbnails')
        .child(fileName);

    final uploadTask = firebaseStorageRef.putData(thumbnailImageBytes);
    final taskSnapshot = await uploadTask.whenComplete(() {});
    final thumbnailUrl = await taskSnapshot.ref.getDownloadURL();

    return thumbnailUrl;
  }

  @override
  Future<String> uploadProfileImage({
    required String url,
    required File image,
  }) async {
    var imageId = const Uuid().v4();

    // Update user profile image.
    if (url.isNotEmpty) {
      final exp = RegExp(r'userProfile_(.*).jpg');
      imageId = exp.firstMatch(url)![1]!;
    }

    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'images/users/userProfile_$imageId.jpg',
    );
    return downloadUrl;
  }

  @override
  Future<String> uploadPostImage({required File image}) async {
    final imageId = const Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'images/posts/post_$imageId.jpg',
    );
    return downloadUrl;
  }
}
