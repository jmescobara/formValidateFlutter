import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class ProductosPovider {
  //aca va la dirección del endpoint
  //sin la pleca "/" final

  final String _url =
      'https://flutter-varios-e1d07-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

//creacion del método para crear productos con la clase de identidad ProductoModel
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

// la url tiene que parsearse a Uri
// peticion http
    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print('decodedData');

    return true;
  }

  //editar un producto
  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

// la url tiene que parsearse a Uri
// peticion http
    final resp =
        await http.put(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print('decodedData');

    return true;
  }

// método que traerá la información de la base de Datos
  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    //contiene codigo de error, status code
    final resp = await http.get(Uri.parse(url));

    // se extrae la informacion de la respuesta
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = [];
    //print(decodedData);
    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      // print(prod);
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      //almacenamos todo en el listado que enviaremos
      productos.add(prodTemp);
    });
    // print(productos[1].id);

    return productos;
  }

  // Método para eliminar de base de datos firebase
  Future<int> borrarProducto(String? id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(Uri.parse(url));

    print(resp.body);
    // print(json.decode(resp.body));

    return 1;
  }

  Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/myflutterdart/image/upload?upload_preset=yzqjzlum');

    final mimeType = mime(imagen.path)!.split("/"); // image/jpeg

    // post y direccion del body
    final imageUploadRequest = http.MultipartRequest('POST', url);

    // key y value del body en el postman
    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    // disparamos la peticion y obtemos la respuesta(postman presion del boton send)
    final streamResponse = await imageUploadRequest.send();

    // respusta del servidor
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
