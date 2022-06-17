import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventou/global.dart';

class UserModel {
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  String? userTag;
  String? profilePicture;
  List<dynamic>? favoriteSales;

  UserModel.empty() {
    id = "";
    email = "";
    firstName = "";
    lastName = "";
    userTag = "";
    profilePicture = "";
    favoriteSales = null;
  }

  UserModel(DocumentSnapshot snapshot) {
    id = snapshot.id;

    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    email = map["email"];
    firstName = map["firstName"];
    lastName = map["lastName"];

    String? tempUserTag = map['userTag'];
    if (tempUserTag == null) {
      userTag = "${firstName} ${lastName[0]}.";
    } else {
      userTag = tempUserTag;
    }

    String? tempProfilePicture = map['profilePicture'];
    if (tempProfilePicture == null) {
      profilePicture = defaultProfilePicture;
    } else {
      profilePicture = tempProfilePicture;
    }

    List<dynamic>? tempFavoriteSales = map['favoriteSales'];
    if (tempFavoriteSales == null) {
      favoriteSales = null;
    } else {
      favoriteSales = tempFavoriteSales;
    }
  }
}