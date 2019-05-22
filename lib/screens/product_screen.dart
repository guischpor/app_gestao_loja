import 'package:app_gestao_loja/blocs/product_bloc.dart';
import 'package:app_gestao_loja/widgets/images_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final Color colorPink600 = Colors.pink[600];

  final Color colorGrey850 = Colors.grey[850];

  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
      );
    }

    return Scaffold(
      backgroundColor: colorGrey850,
      appBar: AppBar(
        backgroundColor: colorPink600,
        elevation: 0,
        title: Text('Criar Produto'),
        centerTitle: false,
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
      body: StreamBuilder<Map>(
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    'Imagens',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  ImagesWidget(
                    context: context,
                    initialValue: snapshot.data['images'],
                    onSaved: (l) {},
                    validator: (l) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['title'],
                    style: _fieldStyle,
                    decoration: _buildDecoration('Título'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['description'],
                    style: _fieldStyle,
                    decoration: _buildDecoration('Descrição'),
                    maxLines: 6,
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['price']?.toStringAsFixed(2),
                    style: _fieldStyle,
                    decoration: _buildDecoration('Preço'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                ],
              ),
            );
          }),
    );
  }
}
