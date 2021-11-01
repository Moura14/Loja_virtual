import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/data/products_data.dart';

class CartProducts {
  String cid;
  String category;
  String pid;

  int quantity;
  String size;

  ProductData productData;

  CartProducts();

  CartProducts.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data['pid'];
    quantity = document.data['quantity'];
    size = document.data["size"];
  }

  Map<String, dynamic> ToMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.resumedMap()
    };
  }
}
