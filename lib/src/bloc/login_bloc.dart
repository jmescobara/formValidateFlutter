import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:formvalidation/src/bloc/validators.dart';

import 'package:rxdart/rxdart.dart';

// agregamos el mixin con la palabra with
class LoginBloc with Validators {
  // final _emailController = StreamController<String>.broadcast();
  // final _passwordController = StreamController<String>.broadcast();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del Stream; escucha la salida del rio; se especifica que fluye atravez del rio
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

// validación del formulario
  Stream<bool> get formValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

  //Insertar valores al Stream
  //hace referencia, no se ejecuta
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // método para cerrar los stream cuando ya no los necesito
  dispose() {
    _emailController.close();
    _passwordController.close();
  }

  //obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
}
