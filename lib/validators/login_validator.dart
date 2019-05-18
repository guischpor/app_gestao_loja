import 'dart:async';

class LoginValidator {
  //validador de email
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Insira um e-mail válido!');
    }
  });

  //validador de senha
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError('Senha inválida, deve conter pelo menos 4 caracteres!');
    }
  });
}
