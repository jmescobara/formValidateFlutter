import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  // final productosProvider = new ProductosPovider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final productosBloc = Provider.productosBlock(context);
    //cargar un listado de productos
    //cambio
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina Princial'),
      ),
      body: Center(
        child: Container(
            constraints: BoxConstraints(
              maxWidth: GetPlatform.isWeb ? 350 : 600,
            ),
            child: _crearListado(productosBloc)),
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBlock productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos?.length,
            itemBuilder: (BuildContext context, int i) =>
                _crearItem(context, productosBloc, productos![i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBlock productosBloc,
      ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red[800],
      ),
      onDismissed: (direction) {
        // productosProvider.borrarProducto(producto.id);
        productosBloc.borrarProductos(producto.id!);
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(producto.fotoUrl),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text('${producto.id}'),
              //navergar a la otra palantalla
              // con el arguments: se envia toda la información a la otra pantalla
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}
