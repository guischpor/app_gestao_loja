import 'package:app_gestao_loja/blocs/orders_bloc.dart';
import 'package:app_gestao_loja/blocs/user_bloc.dart';
import 'package:app_gestao_loja/tabs/orders.tab.dart';
import 'package:app_gestao_loja/tabs/products_tab.dart';
import 'package:app_gestao_loja/tabs/users_tab.dart';
import 'package:app_gestao_loja/widgets/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  final Color colorPink600 = Colors.pink[600];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: colorPink600,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white54),
              ),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                'Clientes',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text(
                'Pedidos',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(
                'Produtos',
              ),
            ),
          ],
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          currentIndex: _page,
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buidFloating(),
    );
  }

  Widget _buidFloating() {
    switch (_page) {
      case 0:
        return null;
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: colorPink600,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: colorPink600,
              ),
              backgroundColor: Colors.white,
              label: 'Concluídos Abaixo',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
                color: colorPink600,
              ),
              backgroundColor: Colors.white,
              label: 'Concluídos Acima',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              },
            ),
          ],
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: colorPink600,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditCategoryDialog(),
            );
          },
        );
    }
  }
}
