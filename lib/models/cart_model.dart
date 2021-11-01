import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/data/cart_products.dart';
import 'package:loja_virtual/models/users_model.dart';
import 'package:loja_virtual/widget/ship_cart.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProducts> products = [];

  String couponCode;
  int discountPercentage = 0;
  bool isLoading = false;
  CartModel(this.user) {
    if (user.isLoggetIn()) _loadCartItems();
  }
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProducts cartProducts) {
    products.add(cartProducts);
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProducts.ToMap())
        .then((doc) {
      cartProducts.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProducts cartProducts) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProducts.cid)
        .delete();

    products.remove(cartProducts);

    notifyListeners();
  }

  void decProducts(CartProducts cartProducts) {
    cartProducts.quantity--;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProducts.cid)
        .updateData(cartProducts.ToMap());

    notifyListeners();
  }

  void incProduct(CartProducts cartProducts) {
    cartProducts.quantity++;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProducts.cid)
        .updateData(cartProducts.ToMap());

    notifyListeners();
  }

  void setCuppon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProducts c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await Firestore.instance.collection('orders').add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((CartProducts) => CartProducts.ToMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection('orders')
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID});
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProducts.fromDocument(doc)).toList();
    notifyListeners();
  }
}
