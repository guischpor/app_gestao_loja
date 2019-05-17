import 'package:app_gestao_loja/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color colorPink600 = Colors.pink[600];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.store,
                      size: 160,
                      color: Colors.pink[600],
                    ),
                    InputField(
                      icon: Icons.person,
                      hint: 'Usuário',
                      obscure: false,
                    ),
                    InputField(
                      icon: Icons.lock,
                      hint: 'Senha',
                      obscure: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: colorPink600,
                        onPressed: () {},
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
