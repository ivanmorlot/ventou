import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ventou/Models/UserModel.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseUsers = FirebaseFirestore.instance.collection("Users");

  setUser(String uid, Map<String, dynamic> map) {
    firebaseUsers.doc(uid).set(map);
  }

  updateUser(String uid, Map<String, dynamic> map) {
    firebaseUsers.doc(uid).update(map);
  }

  deleteUser(String uid) {
    firebaseUsers.doc(uid).delete();
  }

  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot snapshot = await firebaseUsers.doc(uid).get();
    return UserModel(snapshot);
  }

  Future<UserModel> createUser(String email, String password, String firstName, String lastName) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;
    String uid = user.uid;
    Map<String, dynamic> map = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "userTag": "${firstName} ${lastName[0]}.",
      "profilePicture": null,
      "favoriteSales": null,
    };
    setUser(uid, map);
    return getUser(uid);
  }

  String getCurrentUserId() {
    return auth.currentUser!.uid;
  }

  Future<UserModel> connectUser(String email, String password) async {
    UserCredential userCredential =  await auth.signInWithEmailAndPassword(email: email, password: password);
    return getUser(userCredential.user!.uid);
  }

  Future<String> setUserPicture(Uint8List bytes, String pictureName) async {
    String pictureId = "$pictureName-${auth.currentUser!.uid}";
    TaskSnapshot taskSnapshot = await storage.ref("ProfilImage/$pictureId").putData(bytes);
    return await taskSnapshot.ref.getDownloadURL();
  }
}