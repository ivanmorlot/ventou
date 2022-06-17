import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ventou/Services/UserService.dart';
import 'package:ventou/global.dart';
import 'package:file_picker/file_picker.dart';

class ProfileView extends StatefulWidget{
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileViewState();
  }
}

class ProfileViewState extends State<ProfileView> {
  String userTag = globalUser.userTag ?? "";
  bool isEditing = false;
  Uint8List? pictureBytes;
  String? pictureName;
  String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                "Mon profil",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 20),
              InkWell(
                child:
                Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(globalUser.profilePicture!),
                            fit: BoxFit.fitHeight
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.edit, color: Colors.orange),
                    )
                  ],
                ),
                onTap: (){
                  pickPicture();
                },
              ),
              const SizedBox(height: 10),
              (globalUser.profilePicture != defaultProfilePicture) ? ElevatedButton(
                onPressed: () {
                  resetPicture();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    width: 1,
                  ),
                ),
                child: const Text("Supprimer l'avatar"),
              ): Container(),
              const SizedBox(height: 10),
              TextButton.icon(
                  onPressed: (){
                    if (isEditing == true){
                      setState(() {
                        globalUser.userTag = userTag;
                        Map<String,dynamic> map = {
                          "userTag": userTag
                        };
                        UserService().updateUser(globalUser.id, map);
                      });
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  } ,
                  icon: (isEditing)
                    ? const Icon(Icons.check, color: Colors.green,)
                    : const Icon(Icons.edit),
                  label: (isEditing) ? TextField(
                    decoration: const InputDecoration(
                      hintText: "Votre pseudo",
                    ),
                    onChanged: (newUserTag) {
                      setState(() {
                        userTag = newUserTag;
                      });
                    },
                  ):
                  Text(globalUser.userTag!)
              ),
              Text("${globalUser.firstName} ${globalUser.lastName}"),
              Text(globalUser.email),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    Phoenix.rebirth(context);
                  },
                  icon: const Icon(Icons.exit_to_app_sharp),
                  label: const Text("Déconnexion")
              )
            ],
          ),
        ),
      )
    );
  }

  Future pickPicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result != null) {
      pictureName = result.files.first.name;
      pictureBytes = result.files.first.bytes;
      showPopUp();
    }
  }

  resetPicture() {
    setState(() {
      globalUser.profilePicture = defaultProfilePicture;
      pictureUrl = defaultProfilePicture;
    });
    Map<String, dynamic> map = {
      "profilePicture": defaultProfilePicture
    };
    UserService().updateUser(globalUser.id, map);
  }

  showPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text("Photo de profil"),
            content: Image.memory(pictureBytes!),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    width: 1,
                  ),
                ),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  UserService()
                    .setUserPicture(pictureBytes!, pictureName!)
                    .then((picture) {
                      setState(() {
                        globalUser.profilePicture = picture;
                        pictureUrl = picture;
                      });
                      Map<String, dynamic> map = {
                        "profilePicture": pictureUrl
                      };
                      UserService().updateUser(globalUser.id, map);
                      Navigator.pop(context);
                    });
                },
                child: const Text("Enregistrement"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Photo de profil"),
            content: Image.memory(pictureBytes!),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    width: 1,
                  ),
                ),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  UserService()
                    .setUserPicture(pictureBytes!, pictureName!)
                    .then((picture){
                      setState(() {
                        globalUser.profilePicture = picture;
                        pictureUrl = picture;
                      });
                      Map<String, dynamic> map = {
                        "profilePicture": pictureUrl
                      };
                      UserService().updateUser(globalUser.id, map);
                      Navigator.pop(context);
                    });
                },
                child: const Text("Sauvegarder"),
              ),
            ],
          );
        }
      }
    );
  }
}