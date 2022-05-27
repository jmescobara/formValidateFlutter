import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de :
    share_preferences:

  Inicializar el el main
    final prefs = PreferenciasUsuario();
    await prefs.initPrefs();
*/
class PreferenciasUsuario {
//Patron Singlentown
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  //lleva un factory con el nombre de la clase y retorna la variable statica
  factory PreferenciasUsuario() {
    return _instancia;
  }
  //constructor de la clase, que se llama cuando es instanciada
  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  //SharedPreferences? _prefs;

  initPrefs() async {
    //final SharedPreferences prefs = await _prefs;
    //final _prefs = await SharedPreferences.getInstance();
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página
  String get token {
    return _prefs?.getString('token') ?? '';
  }

  set token(String value) {
    _prefs?.setString('token', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs?.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs?.setString('ultimaPagina', value);
  }
}
