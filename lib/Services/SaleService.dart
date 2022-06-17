import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventou/Models/SaleModel.dart';

class SaleService {
  final firebaseSales = FirebaseFirestore.instance.collection("Sales");

  setSale(String uid, Map<String, dynamic> map) {
    firebaseSales.doc(uid).set(map);
  }

  updateSale(String uid, Map<String, dynamic> map) {
    firebaseSales.doc(uid).update(map);
  }

  deleteSale(String uid) {
    firebaseSales.doc(uid).delete();
  }

  Future<SaleModel> getSale(String uid) async {
    DocumentSnapshot snapshot = await firebaseSales.doc(uid).get();
    return SaleModel(snapshot);
  }

  Future<SaleModel> createSale(String userId, String title, String description) async {
    String uid = Uuid().v4();
    Map<String, dynamic> map = {
      "userId": userId,
      "title": title,
      "description": description,
    };
    setSale(uid, map);
    return getSale(uid);
  }
}