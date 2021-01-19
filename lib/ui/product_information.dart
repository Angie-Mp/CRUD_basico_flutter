import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/model/product.dart';

// mostrar informacion del producto
class ProductInformation extends StatefulWidget {
  final Product product;
  ProductInformation(this.product);
  @override
  _ProductInformationState createState() => _ProductInformationState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductInformationState extends State<ProductInformation> {
  List<Product> items;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'informacion del producto',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Center(
            child: Column(
              children: [
                new Text(
                  "Name: ${widget.product.name}",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Divider(),
                new Text(
                  "Codebar: ${widget.product.codebar}",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Divider(),
                new Text(
                  "Description: ${widget.product.description}",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Divider(),
                new Text(
                  "Price: ${widget.product.price}",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Divider(),
                new Text(
                  "Stock: ${widget.product.stock}",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
