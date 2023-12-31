import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vootday_admin/models/models.dart';

class BrandRepository {
  final CollectionReference brandsCollection =
      FirebaseFirestore.instance.collection('brands');

  Future<List<Brand>> getAllBrands() async {
    final QuerySnapshot snap = await brandsCollection.get();
    return snap.docs.map((doc) => Brand.fromDocument(doc)).toList();
  }
}
