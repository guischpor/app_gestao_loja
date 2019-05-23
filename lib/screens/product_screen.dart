import 'package:app_gestao_loja/blocs/product_bloc.dart';
import 'package:app_gestao_loja/validators/product_validator.dart';
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

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      backgroundColor: colorGrey850,
      appBar: AppBar(
        backgroundColor: colorPink600,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? 'Editar Produto' : 'Criar Produto');
            }),
        centerTitle: false,
        actions: <Widget>[
          StreamBuilder<bool>(
              stream: _productBloc.outCreated,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data)
                  return StreamBuilder<bool>(
                      stream: _productBloc.outLoading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: snapshot.data ? null : () {
                            _productBloc.deleteProduct();
                            Navigator.of(context).pop();
                          },
                        );
                      });
                else
                  return Container();
              }),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduct,
                );
              }),
        ],
      ),
      body: StreamBuilder<Map>(
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Stack(
              children: <Widget>[
                Form(
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
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        style: _fieldStyle,
                        decoration: _buildDecoration('Título'),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        style: _fieldStyle,
                        decoration: _buildDecoration('Descrição'),
                        maxLines: 6,
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data['price']?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration('Preço'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                    ],
                  ),
                ),
                StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IgnorePointer(
                        ignoring: !snapshot.data,
                        child: Container(
                          color: snapshot.data
                              ? Colors.black54
                              : Colors.transparent,
                        ),
                      );
                    }),
              ],
            );
          }),
    );
  }

  //função salva produto no firebase
  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //1 snackbar
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Salvando produto...',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
          backgroundColor: colorPink600,
        ),
      );

      bool success = await _productBloc.saveProduct();

      //fechar a primeira snackbar
      _scaffoldKey.currentState.removeCurrentSnackBar();

      //2 snackbar
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Produto salvo!' : 'Erro ao salvar o produto!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: colorPink600,
        ),
      );
    }
  }
}
