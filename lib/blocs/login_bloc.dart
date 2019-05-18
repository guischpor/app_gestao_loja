import 'package:app_gestao_loja/validators/login_validator.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

//estados de login
enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValed => Observable.combineLatest2(
        outEmail,
        outPassword,
        (a, b) => true,
      );

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        print('logou!');
        FirebaseAuth.instance.signOut();
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  //função de login
  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;

    //nesse ponto é informado que a tela esta carregando
    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
  }
}
