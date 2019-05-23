import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    //nesse if caso eu clique em um produto existente ele mostrara todos os dados do produto escolhido
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);

      //o produto ja esta criado
      _createdController.add(true);
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

      //falta ainda criar o produto
      _createdController.add(false);
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

  void saveSizes(List sizes) {
    unsavedData['sizes'] = sizes;
  }

  Future<bool> saveProduct() async {
    //está carregando
    _loadingController.add(true);

    try {
      if (product != null) {
        //função responsavel por realizar o upload das imagens
        await _uploadImages(product.documentID);

        //pegar o produto com as referencias e dar um update com os dados não salvos
        await product.reference.updateData(unsavedData);
      } else {
        //cria o produto, e remove as imagens
        DocumentReference dr = await Firestore.instance
            .collection('products')
            .document(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)..remove('images'));
        //e logo em seguida adiciona as imagens de forma mais correta
        await _uploadImages(dr.documentID);
        //e realiza um update com as imagens corretas
        await dr.updateData(unsavedData);
      }
      //produto ja existe, habilita o botão de remover
      _createdController.add(true);

      //não esta carregando
      _loadingController.add(false);

      //se tudo ocorreu bem
      return true;
    } catch (e) {
      //não esta carregando
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData['images'].length; i++) {
      if (unsavedData['images'][i] is String) continue;

      //função do firebase para upload de arquivo
      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData['images'][i]);

      //nesse ponto ele vai esperar o upload ser completo
      StorageTaskSnapshot s = await uploadTask.onComplete;

      //recuperando a url da imagem
      String downloadUrl = await s.ref.getDownloadURL();

      //recuperado a url, agora o unsabedData recebe a url
      unsavedData['images'][i] = downloadUrl;
    }
  }

  //função para deletar um produto
  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
