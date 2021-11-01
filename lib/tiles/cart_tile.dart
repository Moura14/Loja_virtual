import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_products.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProducts cartProducts;
  CartTile(this.cartProducts);
  //const CartTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProducts.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProducts.productData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho : ${cartProducts.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${cartProducts.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProducts.quantity > 1
                            ? () {
                                CartModel.of(context).decProducts(cartProducts);
                              }
                            : null,
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProducts.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProducts);
                        },
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProducts);
                        },
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProducts.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("products")
                    .document(cartProducts.category)
                    .collection("itens")
                    .document(cartProducts.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProducts.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
