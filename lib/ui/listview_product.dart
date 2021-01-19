import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/model/product.dart';
import 'dart:async';
import 'package:flutter_firebase/ui/product_screen.dart';
import 'package:flutter_firebase/ui/product_information.dart';

//lista de los roductos guardados

class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProductState extends State<ListViewProduct> {
  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onProductAddedSubscription =
        productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription =
        productReference.onChildAdded.listen(_onProductUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'product db',
      home: Scaffold(
        appBar: AppBar(
          title: Text('informacion del producto '),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 12),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    Divider(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                              //muestra el nombre
                              title: Text(
                                '${items[position].name}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 21),
                              ),
                              //muestra la descripcion
                              subtitle: Text(
                                '${items[position].description}',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 21),
                              ),
                              leading: Column(
                                children: [
                                  //muestra el numero de posicion
                                  CircleAvatar(
                                    backgroundColor: Colors.purple[100],
                                    radius: 17,
                                    child: Text(
                                      '${position + 1}',
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 21),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () => _navigateToProductInformation(
                                  context, items[position])),
                        ),
                        //boton eliminar
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteProduct(
                                context, items[position], position)),
                        //boton mostrar informacion
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () =>
                                _navigateToProduct(context, items[position])),
                      ],
                    )
                  ],
                );
              }),
        ),
        //es el boton para crear un nuevo usuario
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.deepPurpleAccent,
          //yo le aumennte el null,segun ejemplo solo va el context
          onPressed: () => _createNewProduct(context, null),
        ), //
      ),
    );
  }

  void _onProductAdded(Event event) {
    setState(() {
      items.add(new Product.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =
        items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProductValue)] =
          new Product.fromSnapShot(event.snapshot);
    });
  }

//boton eliminar
  void _deleteProduct(
      BuildContext context, Product product, int position) async {
    await productReference.child(product.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

//dirige a la otra pantalla de list_product
  void _navigateToProductInformation(
      BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen(product)),
    );
  }

// boton mostrar informcaion
  void _navigateToProduct(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductInformation(product)),
    );
  }

//crear nuevo usuario
  void _createNewProduct(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductScreen(Product(null, '', '', '', '', ''))),
    );
  }
}
