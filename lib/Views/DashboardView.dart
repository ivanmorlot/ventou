import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ventou/Models/SaleModel.dart';
import 'package:ventou/Services/SaleService.dart';
import 'package:ventou/global.dart';

class DashboardView extends StatelessWidget  {
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
              itemBuilder: (context, index){
                SaleModel sale = SaleModel(documents[index]);
                if (globalUser.id == sale.userId) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      SaleService().deleteSale(sale.id);

                      final scaffold = ScaffoldMessenger.of(context);
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1, milliseconds: 500),
                          backgroundColor: Colors.deepOrange,
                          content: Row(
                            children: [
                              Text(
                                  sale.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                              const Text('  supprimé(e)(s)'),
                            ],
                          ),
                          action: SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white),
                        ),
                      );
                    },
                    key: Key(sale.id),
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          // TODO: Sale edit redirection
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
                          backgroundColor: Colors.green,
                        ),
                        title: Text(sale.title),
                        subtitle: const Text("Annonce personnelle"),
                        trailing: Image.network("https://icons.iconarchive.com/icons/custom-icon-design/flatastic-4/512/Sale-icon.png"),
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
