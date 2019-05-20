import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  //constructor
  UserBloc() {
    _addUsersListener();
  }

  //função que sempre sera chamado quando o users tiver alguma alteração
  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  //função que verifica se existe novos pedidos na coleção users
  void _subscribeToOrders(String uid) {
    _users[uid]['subscription'] = _firestore
        .collection('users')
        .document(uid)
        .collection('orders')
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;

      for (DocumentSnapshot d in orders.documents) {
        DocumentSnapshot order =
            await _firestore.collection('orders').document(d.documentID).get();

        if (order.data == null) continue;

        money += order.data['totalPrice'];
      }

      //montando a lista
      _users[uid].addAll({'money': money, 'orders': numOrders});

      //add a lista ao controlador
      _usersController.add(_users.values.toList());
    });
  }

  //função que apaga a lista caso vazia
  void _unsubscribeToOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
