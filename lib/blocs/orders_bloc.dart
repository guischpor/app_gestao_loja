import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _orders = [];

  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((changes) {
        String oid = changes.document.documentID;

        switch (changes.type) {
          case DocumentChangeType.added:
            _orders.add(changes.document);
            break;
          case DocumentChangeType.modified:
            _orders.retainWhere((order) => order.documentID == oid);
            _orders.add((changes.document));
            break;
          case DocumentChangeType.removed:
            _orders.retainWhere((order) => order.documentID == oid);
            break;
        }
      });
      _ordersController.add(_orders);
    });
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
