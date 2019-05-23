import 'package:app_gestao_loja/blocs/user_bloc.dart';
import 'package:app_gestao_loja/widgets/user_tiles.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  final Color colorPink600 = Colors.pink[600];

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Pesquisar',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
            child: StreamBuilder<List>(
          stream: _userBloc.outUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorPink600),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'Nenhum usuário encontrado!',
                  style: TextStyle(
                    color: colorPink600,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return UserTile(snapshot.data[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.length,
              );
            }
          },
        ))
      ],
    );
  }
}
