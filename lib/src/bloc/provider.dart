import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

import 'package:formvalidation/src/bloc/productos_bloc.dart';
export 'package:formvalidation/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productosBloc = new ProductosBlock();

  static Provider? _instancia;

  factory Provider({Key? key, required Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia!;
  }

  Provider._internal({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .loginBloc;
  }

  static ProductosBlock productosBlock(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._productosBloc;
  }
}
