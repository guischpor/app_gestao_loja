import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();

  Stream<Map> get outData => _dataController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<dynamic, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    //nesse if caso eu clique em um produto existente ele mostrara todos os dados do produto escolhido
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);
    }
    //caso for null, ou seja eu clicar em adicionar produto, ele abrira a tela com os campos vazios
    else {
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': []
      };
    }

    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
