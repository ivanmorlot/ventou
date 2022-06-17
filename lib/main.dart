import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ventou/Services/UserService.dart';
import 'package:ventou/global.dart';
import 'package:ventou/Views/ShelterView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Phoenix(
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventou',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MainPage(title: 'Ventou'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isNewVisitor = true;
  String email = "";
  String password = "";
  String firstName = "";
  String lastName = "";
  List<bool> selection = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            height : 80,
            decoration : const BoxDecoration(
                shape : BoxShape.circle,
                image : DecorationImage(
                  image : NetworkImage("https://www.teamaxe.com/img/cms/shop_106574.png"),
                )
            ),
          ),
          title: Text(widget.title),
        ),
        body: Padding(
          child : bodyPage(),
          padding : const EdgeInsets.all(10),
        )
    );
  }

  Widget bodyPage(){
    return SingleChildScrollView(
      child: Column(
        children : [
          const SizedBox(height : 20),
          const Text("Bienvenue sur Ventou !", style: TextStyle(fontSize: 28)),
          const SizedBox(height : 10),
          const Text("L'application phare de la vente entre particuliers", style: TextStyle(fontSize: 16)),
          const SizedBox(height : 30),
          ToggleButtons(
            borderRadius: BorderRadius.circular(10),
            isSelected: selection,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Inscription"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Connexion"),
              ),
            ],
            onPressed: (index) {
              if (index == 0) {
                setState(() {
                  selection[0] = true;
                  selection[1] = false;
                  isNewVisitor = true;
                });
              } else {
                setState(() {
                  selection[0] = false;
                  selection[1] = true;
                  isNewVisitor = false;
                });
              }
            },
          ),
          const SizedBox(height : 20),
          (isNewVisitor) ? TextField(
              decoration : InputDecoration(
                  hintText : "Entrer votre prénom",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged: (String value) {
                setState(() {
                  firstName = value;
                });
              }
          ): Container(),
          (isNewVisitor) ? const SizedBox(height : 10): Container(),
          (isNewVisitor) ? TextField(
              decoration : InputDecoration(
                  hintText : "Entrer votre nom",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged : (String value) {
                setState(() {
                  lastName = value;
                });
              }
          ): Container(),
          (isNewVisitor) ? const SizedBox(height : 10): Container(),
          TextField(
              decoration : InputDecoration(
                  hintText : "Entrer votre email",
                  icon : const Icon(Icons.mail),
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged : (String value) {
                setState(() {
                  email = value;
                });
              }
          ),
          const SizedBox(height : 10),
          TextField(
              obscureText : true,
              decoration : InputDecoration(
                hintText : "Entrer votre mot de passe",
                icon : const Icon(Icons.lock),
                border : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              onChanged : (value) {
                setState(() {
                  password = value;
                });
              }
          ),
          const SizedBox(height : 10),
          ElevatedButton(
              onPressed: () {
                if (isNewVisitor == true) {
                  register();
                } else {
                  connect();
                }
              },
              child : Text("Validation")
          )
        ],
      ),
    );
  }

  register() {
    UserService()
      .createUser(email, password, firstName, lastName)
      .then((user) {
        setState(() {
          globalUser = user;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ShelterView();
            }
          )
        );
      })
      .catchError((error) => print(error));
  }

  connect(){
    UserService()
      .connectUser(email, password)
      .then((user) {
        setState(() {
          globalUser = user;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ShelterView();
            }
          )
        );
      })
      .catchError((error) => print(error));
  }
}
