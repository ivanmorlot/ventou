import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  late String id;
  late String userId;
  late String title;
  late String description;

  SaleModel.empty() {
    id = "";
    userId = "";
    title = "";
    description = "";
  }

  SaleModel(DocumentSnapshot snapshot) {
    id = snapshot.id;

    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    userId = map["userId"];
    title = map["title"];
    description = map["description"];
  }
}