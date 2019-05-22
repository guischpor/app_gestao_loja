import 'package:app_gestao_loja/screens/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryTile(this.category);

  final Color colorPink600 = Colors.pink[600];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              category.data['icon'],
            ),
          ),
          title: Text(
            category.data['title'],
            style: TextStyle(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection('items').getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container();
                else
                  return Column(
                    children: snapshot.data.documents.map<Widget>(
                      (doc) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(doc.data['images'][0]),
                          ),
                          title: Text(doc.data['title']),
                          trailing: Text(
                            "R\$${doc.data['price'].toStringAsFixed(2)}",
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ).toList()
                      ..add(
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.add,
                              color: colorPink600,
                            ),
                          ),
                          title: Text(
                            'Adicionar',
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                  );
              },
            )
          ],
        ),
      ),
    );
  }
}
