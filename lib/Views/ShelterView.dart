import 'package:flutter/material.dart';
import 'package:ventou/Views/DashboardView.dart';
import 'package:ventou/Views/ProfileView.dart';
import 'package:ventou/Views/SalesView.dart';
import 'package:ventou/Views/FavoriteView.dart';
import 'package:ventou/Services/UserService.dart';
import 'package:ventou/Services/SaleService.dart';
import 'package:ventou/global.dart';

class ShelterView extends StatefulWidget {
  const ShelterView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShelterViewState();
  }
}

class ShelterViewState extends State<ShelterView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ProfileView(),
      ),
      appBar : AppBar(
        title : const Text("Ventou"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.person,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          (selectedIndex == 0) ? Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // TODO: Add a sale on tap and replace following demo code
                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2, milliseconds: 500),
                      backgroundColor: Colors.yellow,
                      content: const Text(
                          "Fonctionnalité en mode démo",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          )
                      ),
                      action: SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.black),
                    ),
                  );

                  String currentUserId = UserService().getCurrentUserId();
                  SaleService().createSale(
                      currentUserId,
                      "Test - ${globalUser.userTag!}",
                      "Description de test"
                  );
                },
                child: Icon(
                    Icons.add
                ),
              )
          ): Container(),
        ],
      ),
      body : getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: "Mes annonces",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favoris",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Parcourir",
          )
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody( )  {
    if (selectedIndex == 0) {
      return DashboardView();
    } else if (selectedIndex == 1) {
      return FavoriteView();
    } else {
      return SalesView();
    }
  }

  void onTapHandler(int index)  {
    setState(() {
      selectedIndex = index;
    });
  }
}
