import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ventou/Models/SaleModel.dart';
import 'package:ventou/Services/UserService.dart';
import 'package:ventou/Services/SaleService.dart';
import 'package:ventou/global.dart';

class SalesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: SaleService().firebaseSales.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                SaleModel sale = SaleModel(documents[index]);

                if (globalUser.id != sale.userId) {
                  return Container(
                    key: Key(sale.id),
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          // TODO: Sale details redirection
                          final scaffold = ScaffoldMessenger.of(context);
                          scaffold.hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2, milliseconds: 500),
                              backgroundColor: Colors.yellow,
                              content: const Text(
                                  "Fonctionnalité en développement",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  )
                              ),
                              action: SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.black),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          child: Text(sale.title[0]),
                          backgroundColor: Colors.blue,
                        ),
                        title: Text(sale.title),
                        subtitle: Text("Annonce de vente"),
                        trailing: IconButton(
                          icon: const Icon(Icons.star),
                          onPressed: () {
                            UserService().getUser(globalUser.id).then((user) {
                              List<dynamic> list = [];

                              if (user.favoriteSales != null) {
                                list = user.favoriteSales!;
                              }

                              if (list.contains(sale.id)) {
                                list.remove(sale.id);
                              } else {
                                list.add(sale.id);
                              }

                              UserService().updateUser(globalUser.id, {
                                "favoriteSales": list,
                              });
                              UserService().getUser(globalUser.id).then((user) => globalUser = user);

                              var isFavorite = globalUser.favoriteSales!.contains(sale.id);
                              final scaffold = ScaffoldMessenger.of(context);
                              scaffold.hideCurrentSnackBar();
                              scaffold.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1, milliseconds: 500),
                                  backgroundColor: isFavorite
                                    ? Colors.deepOrange
                                    : Colors.lightGreen,
                                  content: Row(
                                    children: [
                                      Text(
                                        sale.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                      ),
                                      isFavorite
                                        ? const Text('  retiré des favoris')
                                        : const Text('  ajouté aux favoris'),
                                    ],
                                  ),
                                  action: SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        }
    );
  }
}
