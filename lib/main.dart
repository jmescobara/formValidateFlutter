import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:formvalidation/src/pages/registro_page.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    print(prefs.token);

    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext contex) => LoginPage(),
        'registro': (BuildContext contex) => RegistroPage(),
        'home': (BuildContext contex) => HomePage(),
        'producto': (BuildContext contex) => ProductoPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
      ),
    ));
  }
}


/**
con esto se puede subir el proyecto a Git desde la terminal de vscode
1. crear repositorio en la web
2. copiar los comandos y pegarlos aca:
  git remote add origin https://github.com/jmescobara/formValidateFlutter.git
  git branch -M main
  git push -u origin main
3. finalizar con esta lineas de codigo:
  git commit -m "initial commit"
  git push origin main
 */