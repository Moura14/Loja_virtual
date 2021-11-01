import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_products.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/users_model.dart';
import 'package:loja_virtual/screens/cart_screens.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProdutctScreen extends StatefulWidget {
  final ProductData product;
  ProdutctScreen(this.product);
  //const ProdutctScreen({Key key}) : super(key: key);

  @override
  _ProdutctScreenState createState() => _ProdutctScreenState(product);
}

class _ProdutctScreenState extends State<ProdutctScreen> {
  final ProductData product;
  String size;
  _ProdutctScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 0.8,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.title,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                  Text(
                    "R\$ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Tamanho",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5),
                      children: product.sizes.map((s) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                      color: s == size
                                          ? primaryColor
                                          : Colors.grey[500],
                                      width: 3.0)),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(s),
                            ));
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        onPressed: size != null
                            ? () {
                                if (UserModel.of(context).isLoggetIn()) {
                                  CartProducts cartProducts = CartProducts();
                                  cartProducts.size = size;
                                  cartProducts.quantity = 1;
                                  cartProducts.pid = product.Id;
                                  cartProducts.category = product.category;
                                  cartProducts.productData = product;
                                  //adicionar ao carrinho
                                  CartModel.of(context)
                                      .addCartItem(cartProducts);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CartScreen()));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                }
                              }
                            : null,
                        child: Text(
                          UserModel.of(context).isLoggetIn()
                              ? "Adicionar ao Carrinho"
                              : "Entre para comprar",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        color: primaryColor,
                        textColor: Colors.white,
                      )),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Descrição",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
