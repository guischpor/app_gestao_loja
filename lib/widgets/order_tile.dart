import 'package:flutter/material.dart';
import 'order_header.dart';

class OrderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            '#123545 - Entregue',
            style: TextStyle(color: Colors.green),
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
                  OrderHeader(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Camiseta Preta GG'),
                        subtitle: Text('camiseta/preta'),
                        trailing: Text(
                          '2',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {},
                        child: Text('Excluir'),
                      ),
                      FlatButton(
                        textColor: Colors.grey[850],
                        onPressed: () {},
                        child: Text('Regredir'),
                      ),
                      FlatButton(
                        textColor: Colors.green,
                        onPressed: () {},
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
