// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/producto_model.dart';
// import 'package:formvalidation/src/providers/productos_providers.dart';

import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
// Generamos la clave unica para el form
  final formKey = GlobalKey<FormState>();
  // auto generacioón de id del scaffold
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // final productoProvider = ProductosPovider();

  late ProductosBlock productosBloc;
  ProductoModel producto = new ProductoModel();

  bool _guardando = false;
  File? foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBlock(context);
    // ésta es una de las formas para recibir argumentos de otra página
    final Object? prodData = ModalRoute.of(context)!.settings.arguments;
    if (prodData != null) {
      producto = prodData as ProductoModel;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: GetPlatform.isWeb ? 350 : 600,
            ),
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _mostrarFoto(),
                    _crearNobre(),
                    _crearPrecio(),
                    _crearDisponible(),
                    _crearBoton(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _crearNobre() {
    return TextFormField(
      //aca vamos a enlazar nuestro modelo con el campo
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      //se ejecuta despues de haber validado el campo, caputa la información que se introduce
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      //aca vamos a enlazar nuestro modelo con el campo, espara String y vine double (por eso .toString())
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      title: Text('Disponible'),
      value: producto.disponible,
      onChanged: (bool value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      ),
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      //si guardando es true sera null, si no que se ejecute
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    // Ejecutamos el estado actual del formulario

    // si el formulario no es válido
    if (!formKey.currentState!.validate()) return;

    // guarda todo los datos del formulario
    formKey.currentState!.save();

    // print(producto.titulo);
    // print(producto.valor);
    // print(producto.disponible);
    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = (await productosBloc.subirFoto(foto!))!;
    }

    if (producto.id == null) {
      productosBloc.agregarProductos(producto);
    } else {
      productosBloc.editarProductos(producto);
    }

    // setState(() {
    //   _guardando = false;
    // });

    // mensaje de guardado de registro
    mostrarSnackbar('Registro guardado');

    // toca el boton y te regresa a la pantalla homepage
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    // Get.snackbar('Producto:', mensaje,
    //     snackPosition: SnackPosition.TOP,
    //     duration: const Duration(seconds: 3),
    //     backgroundColor: Colors.lightBlue,
    //     icon: const Icon(Icons.message_rounded));

    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 3000),
      backgroundColor: Colors.blue,
    );

    //   // //scaffoldKey.currentState?.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   //ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        //height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

// llamar fotos e imagenes ----
  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = (await ImagePicker.pickImage(
      source: origen,
    ));

    if (foto != null) {
      producto.fotoUrl = '';
    }

    setState(() {});
  }

  // hasta aca 3 metodos
}
