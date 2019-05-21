import 'package:app_gestao_loja/blocs/orders_bloc.dart';
import 'package:app_gestao_loja/widgets/order_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  final Color colorPink600 = Colors.pink[600];

  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.of<OrdersBloc>(context);

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorPink600),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'Nenhum Pedido Encontrado',
                  style: TextStyle(
                    color: colorPink600,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return OrderTile(snapshot.data[index]);
              },
            );
          },
        ));
  }
}
