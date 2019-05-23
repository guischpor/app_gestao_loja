import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entrega'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data['status'] != 4,
          title: Text(
            "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - "
            "${states[order.data['status']]}",
            style: TextStyle(
                color: order.data['status'] != 4
                    ? Colors.grey[850]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: order.data['products'].map<Widget>((p) {
                        return ListTile(
                          title: Text(p['product']['title'] + " " + p['size']),
                          subtitle: Text(p['category'] + '/' + p['pid']),
                          trailing: Text(
                            p['quantity'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          //deleta na lista de pedidos do usuario
                          Firestore.instance
                              .collection('users')
                              .document(order['clientId'])
                              .collection('orders')
                              .document(order.documentID)
                              .delete();

                          //deleta na lista de pedidos
                          order.reference.delete();
                        },
                        child: Text('Excluir'),
                      ),
                      FlatButton(
                        textColor: Colors.grey[850],
                        onPressed: order.data['status'] > 1
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] - 1});
                              }
                            : null,
                        child: Text('Regredir'),
                      ),
                      FlatButton(
                        textColor: Colors.green,
                        onPressed: order.data['status'] < 4
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] + 1});
                              }
                            : null,
                        child: Text('Avançar'),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
