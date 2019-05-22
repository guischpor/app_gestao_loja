import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
