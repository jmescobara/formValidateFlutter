import 'package:flutter/material.dart';

bool isNumeric(String? s) {
  if (s!.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('información incorrecta'),
        content: Text(mensaje),
        actions: [
          FlatButton(
            child: Text('Ok'),
            //cerrar la alerta
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        elevation: 25.0,
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      );
    },
  );
}
