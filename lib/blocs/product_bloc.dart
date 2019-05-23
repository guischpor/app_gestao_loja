import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

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

  void saveTitle(String title) {
    unsavedData['title'] = title;
  }

  void saveDescription(String description) {
    unsavedData['description'] = description;
  }

  void savePrice(String price) {
    unsavedData['price'] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData['images'] = images;
  }

  Future<bool> saveProduct() async {
    //está carregando
    _loadingController.add(true);

    await Future.delayed(Duration(seconds: 3));

    //não esta carregando
    _loadingController.add(false);
    return true;
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
  }
}
