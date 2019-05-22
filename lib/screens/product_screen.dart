import 'package:app_gestao_loja/blocs/product_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String categoryId;
  final DocumentSnapshot product;

  final _formKey = GlobalKey<FormState>();

  final Color colorPink600 = Colors.pink[600];
  final Color colorGrey850 = Colors.grey[850];

  final ProductBloc _productBloc;

  ProductScreen({this.categoryId, this.product})
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorGrey850,
      appBar: AppBar(
        backgroundColor: colorGrey850,
        elevation: 0,
        title: Text('Criar Produto'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[],
        ),
      ),
    );
  }
}
